# C'est le fichier qui contient les valeurs concrètes des variables. 
# C'est le seul fichier qui change d'un environnement à l'autre 
proxmox_endpoint = "https://10.10.1.10:8006/"

proxmox_token = "terraform@pve!terraform-token=f3136817-7aac-45b2-9f60-d3137d45f573"

ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuzplCq7WPjI1pPeM1UDIvDL1ng+FmUzUVey/ZZF3Bd k8s-lab"

template_id = 9000

gateway = "10.10.1.1"

# Terraform charge ce fichier automatiquement s'il s'appelle terraform.tfvars. 
# Si tu veux plusieurs environnements tu peux avoir prod.tfvars 
# et dev.tfvars et les passer avec terraform apply -var-file=prod.tfvars