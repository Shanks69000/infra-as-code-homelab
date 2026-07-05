# Setup Terraform pour Proxmox VE

## Prérequis

- Proxmox VE 8.x ou 9.x
- Un template cloud-init (Debian 12 recommandé)
- Terraform >= 1.5

## Créer le token API Terraform sur Proxmox

Depuis le shell Proxmox (SSH ou console web) :

```bash
# Créer le rôle avec les privilèges nécessaires
# Note : VM.Monitor a été retiré dans PVE 9.1
pveum role add TerraformRole -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt SDN.Use"

# Créer l'utilisateur dédié
pveum user add terraform@pve

# Associer le rôle
pveum aclmod / -user terraform@pve -role TerraformRole

# Générer le token API (--privsep=0 = hérite des permissions du user)
pveum user token add terraform@pve terraform-token --privsep=0
```

Le token affiché a le format `terraform@pve!terraform-token=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`. À renseigner dans `terraform.tfvars`.

## Initialiser et déployer

```bash
cd terraform/projects/k8s-lab
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars avec endpoint, token, clé SSH

terraform init
terraform plan    # Vérifier avant d'appliquer
terraform apply
```

## Équivalent AWS

```bash
# Installer AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip && sudo ./aws/install

# Configurer les credentials
aws configure
# → Access Key ID, Secret Access Key, Region (eu-west-3 pour Paris)

# Ou via variables d'environnement
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_DEFAULT_REGION="eu-west-3"
```

Provider Terraform AWS :
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

Ref : https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Équivalent Azure

```bash
# Installer Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Se connecter
az login

# Créer un Service Principal pour Terraform
az ad sp create-for-rbac --name "terraform" --role Contributor \
  --scopes /subscriptions/SUBSCRIPTION_ID
```

Provider Terraform Azure :
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
```

Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs