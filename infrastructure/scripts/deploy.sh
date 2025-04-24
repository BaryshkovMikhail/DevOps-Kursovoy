#!/bin/bash

# Инициализация Terraform
cd terraform
terraform init

# Применение конфигурации Terraform
terraform apply -auto-approve \
  -var="yc_token=$(yc iam create-token)" \
  -var="yc_cloud_id=$(yc config get cloud-id)" \
  -var="yc_folder_id=$(yc config get folder-id)" \
  -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"

# Генерация инвентаря Ansible
terraform output -json | jq -r '@sh "export BASTION_IP=\(.bastion_ip.value)"' > ../ansible/inventory.ini
echo "[web_servers]" >> ../ansible/inventory.ini
terraform output -json web_ips | jq -r '.[]' >> ../ansible/inventory.ini

# Запуск Ansible
cd ../ansible
ansible-playbook -i inventory.ini playbooks/site.yml