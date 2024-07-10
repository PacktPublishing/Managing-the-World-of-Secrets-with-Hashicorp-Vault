#!/bin/bash

# Download and add the repository key
wgetO- https://apt.releases.hashicorp.com/gpg | sudo gpg-dearmoro /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg-no-default-keyring-keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg-fingerprint

echo "deb [arch=$(dpkg-print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_releasecs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Vault
sudo apt update && sudo apt install vault

# Configure Vault to service to start when the VM boots
sudo systemctl enable vault.service

# Start the service
sudo systemctl start vault.service

# Show status to verify the Vault service has started
systemctl status vault.service

