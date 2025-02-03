#!/bin/bash
echo "🚀 Déploiement avec Terraform et Ansible..."

# Charger les secrets depuis GitHub Codespaces
export PM_API_URL=$PM_API_URL
export PM_API_TOKEN_ID=$PM_API_TOKEN_ID
export PM_API_TOKEN_SECRET=$PM_API_TOKEN_SECRET
export PROXMOX_PUBLIC_IP=$PROXMOX_PUBLIC_IP

# Déployer Terraform
cd terraform
terraform init
terraform apply -auto-approve \
  -var "pm_api_url=$API_URL" \
  -var "pm_api_token_id=$PM_API_TOKEN_ID" \
  -var "pm_api_token_secret=$API_TOKEN_ID" \
  -var "proxmox_public_ip=$PROXMOX_PUBLIC_IP"

# Mettre à jour l’inventaire Ansible avec l’IP publique de Proxmox
echo "[proxmox]" > ../ansible/inventory/proxmox.ini
echo "$PROXMOX_PUBLIC_IP ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa" >> ../ansible/inventory/proxmox.ini

# Exécuter Ansible pour configurer les VMs via Proxmox
cd ../ansible
ansible-playbook -i inventory/proxmox.ini playbooks/setup.yml
