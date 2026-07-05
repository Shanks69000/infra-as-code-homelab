# Homelab Infrastructure as Code

Provisionnement et configuration automatisés d'un homelab Proxmox VE hébergeant un cluster Kubernetes (K3s), un serveur de bases de données et des services applicatifs.

## Architecture
Proxmox VE (hyperviseur)
```
├── bastion          (10.10.1.11)  — point d'entrée SSH
├── k8s-master       (10.10.1.20)  — control plane K3s
├── k8s-worker1      (10.10.1.21)  — worker node
├── k8s-worker2      (10.10.1.22)  — worker node
└── db-server        (10.10.1.30)  — PostgreSQL 16 + MariaDB + NFS
│
└──► Cluster K3s
├── apps/       Homer, Gitea, IT-Tools, Authentik, Vaultwarden, Woodpecker CI
└── monitoring/ kube-prometheus-stack (Grafana)
```
## Stack technique

| Couche | Outils |
|---|---|
| Provisionnement | Terraform (provider [bpg/proxmox](https://github.com/bpg/terraform-provider-proxmox)), cloud-init |
| Configuration | Ansible (playbooks, roles) |
| Orchestration | K3s (Kubernetes léger) |
| Applications | Manifests YAML, Helm values |
| Scripting | Bash (orchestration deploy) |

## Structure du projet
```
.
├── docs/
│   └── proxmox-setup.md  # Guide setup token API Terraform (Proxmox, AWS, Azure)
├── terraform/
│   ├── modules/vm/          # Module réutilisable — VM Proxmox (clone, CPU, RAM, disk, cloud-init)
│   └── projects/
│       ├── k8s-lab/          # 5 VMs : bastion + cluster K3s 3 nodes + DB server
│       └── monitoring/       # VM Grafana dédiée
├── ansible/
│   ├── playbooks/
│   │   ├── base.yml          # Hardening OS, paquets, timezone, swap off
│   │   ├── k3s.yml           # Installation K3s master + join workers
│   │   ├── db-server.yml     # PostgreSQL 16 + MariaDB + users/databases
│   │   └── nfs-server.yml    # NFS pour PersistentVolumes K8s
│   ├── roles/proxmox-setup/  # Post-install Proxmox (qemu-guest-agent, réseau)
│   └── group_vars/all/       # Variables chiffrées (ansible-vault)
├── kubernetes/
│   ├── apps/                 # Manifests par application (Deployment, Service, Ingress)
│   └── monitoring/           # kube-prometheus-stack
└── scripts/
└── deploy_all.sh         # Terraform apply → wait SSH → Ansible playbook
```

## Workflow de déploiement

```bash
# 1. Provisionner les VMs
cd terraform/projects/k8s-lab
cp terraform.tfvars.example terraform.tfvars  # Renseigner endpoint, token, clé SSH
terraform init && terraform apply

# 2. Configurer les VMs
cd ../../ansible
cp group_vars/all/vault.yml.exemple group_vars/all/vault.yml
ansible-vault encrypt group_vars/all/vault.yml
ansible-playbook playbooks/base.yml
ansible-playbook playbooks/k3s.yml
ansible-playbook playbooks/db-server.yml
ansible-playbook playbooks/nfs-server.yml

# 3. Déployer les applications K8s
kubectl apply -f ../kubernetes/apps/homer/homer.yml
kubectl apply -f ../kubernetes/apps/it-tools/it-tools.yml
# Les apps avec secrets utilisent des .example à adapter
```

Ou en une commande via le script d'orchestration :
```bash
./scripts/deploy_all.sh
```

## Gestion des secrets

Les secrets sont externalisés et ne sont **jamais commités** :

- **Terraform** : `terraform.tfvars` (gitignored), un `.tfvars.example` avec placeholders est fourni
- **Ansible** : `vault.yml` chiffré via `ansible-vault`, un `.exemple` avec `CHANGEME` est fourni
- **Kubernetes** : les manifests contenant des credentials ont un `.example` associé

En production, j'utiliserais [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) ou [External Secrets Operator](https://external-secrets.io/) intégré à HashiCorp Vault.

## Prérequis

- Proxmox VE 8.x avec un template cloud-init (Debian 12)
- Terraform >= 1.5
- Ansible >= 2.15
- kubectl configuré avec le kubeconfig K3s

## Ce que ce projet démontre

- **Infrastructure as Code** : provisionnement déclaratif de VMs via Terraform avec module réutilisable et `for_each`
- **Configuration Management** : playbooks Ansible idempotents pour l'OS, K3s, bases de données, stockage
- **Orchestration conteneurs** : déploiement d'applications sur Kubernetes avec Ingress, PVC, namespaces
- **Hygiène secrets** : séparation stricte code/credentials, pattern `.example`, ansible-vault
- **Workflow complet** : du bare-metal Proxmox jusqu'aux applications accessibles via Ingress
