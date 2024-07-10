#!/bin/sh
# Download and move latest Vault release to bin.
printf "\n\nFetching Vault binary"
cd /opt/ && sudo curlo vault.zip https://releases.hashicorp.com/vault/1.13.1/vault_1.13.1_linux_amd64.zip
sudo unzip vault.zip
sudo mv vault /usr/bin/

# Create a user named vault to be run as a service.
printf "\n\nCreating vault user"
sudo useradd-system-home /etc/vault.d-shell /bin/false vault

# Configure Vault as a System Service
printf "\n\nConfiguring vault as system service"
sudo wget https://gitlab.com/secureclouds/vault/-/raw/main/Vault-on-ec2/Non-TLS/non-tls-vault.service
sudo mv  non-tls-vault.service /etc/systemd/system/vault.service

sudo mkdir /etc/vault.d
sudo chownR vault:vault /etc/vault.d
sudo mkdir /vault-data
sudo chownR vault:vault /vault-data
sudo mkdirp /opt/vault/logs/

# ??? What is this file from secureclouds
sudo wget https://gitlab.com/secureclouds/vault/-/raw/main/Vault-on-ec2/Non-TLS/non-tls.hcl
sudo mv non-tls.hcl /etc/vault.d/vault.hcl

# Start vault as a service
echo "Configure and start vault.service"
sudo systemctl start vault
sudo systemctl status vault
sudo systemctl enable vault