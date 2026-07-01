#!/usr/bin/env bash
# deploy_all.sh
# Script qui initialise terraform, crée les VMs et lance Ansible une fois que les VMs répondent en SSH.


set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR/terraform"


echo "Initialisation Terraform..."
terraform init


echo "Appliquer configuration Terraform (création VMs)..."
terraform apply -auto-approve


# Après création, tenter d'attendre la disponibilité SSH avant d'exécuter Ansible
cd "$ROOT_DIR/ansible"


# Fonction d'attente SSH
wait_for_ssh() {
host="$1"
echo "Attente SSH sur $host ..."
for i in {1..60}; do
if nc -z -w 2 $host 22; then
echo "SSH disponible sur $host"
return 0
fi
sleep 5
done
echo "Timeout SSH pour $host"
return 1
}


hosts=("10.x.x.16" "10.x.x.17" "10.x.x.18")
for h in "${hosts[@]}"; do
wait_for_ssh "$h" || echo "Attention: $h ne répond pas sur le port 22. Installez Proxmox ou vérifiez la config.";
done


echo "Lancement d'Ansible playbook..."
ansible-playbook -i inventory.ini playbook-proxmox-postinstall.yml --ask-become-pass


echo "Terminé."