#!/bin/bash

### USE THESE COMMANDS SEPARATELY ###
# They were NOT intended to be used as a script

sudo scp -i "vault-kp1.pem" root_2024_ca.crt ubuntu@ec2-18-119-162-200.us-east-2.compute.amazonaws.com:/tmp

# After you SSH into the instance
cp -p /tmp/root_2024_ca.crt /opt/vault/tls/ 
sudo chown vault:vault /opt/vault/tls/root_2024_ca.crt
sudo chmod 400 /opt/vault/tls/root_2024_ca.crt

# Use this command to:
# - diagnose startup failures
# - validate your configuration (/etc/vault.d/vault.hcl) and detect problems in it
vault operator diagnose -config= /etc/vault.d/vault.hcl

mkdir /opt/vault.d/

# Use one of the following to cfix the ownership.
# If you followed the instructions in the chapter, the directory will initially be owned by root
# The first command should be sufficient, if you have not yet attempted to start Vault
chown vault:vault -R /opt/vault.d/
chown vault:vault -R /opt/vault.d*

# Set Vault address, ignoring self-signed cert, and CA Cert
# You will need these variables on every login, so consider putting it in root's .bashrc
export VAULT_SKIP_VERIFY=true
export VAULT_ADDR="https://127.0.0.1:8200"
export VAULT_CACERT=/opt/vault/tls/root_2024_ca.crt

# Enable KV secrets engine, v2
vault secrets enable -version=2 kv



vault operator init -key-shares=1 -key-threshold=1

# After you intialize and save the unseal keys and root toke, before you do anything set this
export VAULT_TOKEN=<root_token>
export VAULT_TOKEN=hvs.kcrJBzcqRAfKv3qMsIUtvChE

# Enter the unseal key after you run this command (this time only one)
vault operator unseal

touch set_env_vars.sh
chmod u+x set_env_vars.sh

# Get standby node to join the cluster. DO NOT intialize Vault on that node!
vault operator raft join https://172.31.11.139:8200

# With Load Balancer - fill the placeholder at the end of the command with the IP of your load balencer
vault operator raft join -leader-ca-cert=@/opt/vault/tls/root_2024_ca.crt -leader-client-cert=@/opt/vault/tls/tls.crt -leader-client-key=@/opt/vault/tls/tls.key <https://load-balacner-IP:8200>

# Create key pair
# You have to manually copy the key material into a file on your drive
aws ec2 create-key-pair --key-name sample-kp1 --key-format=pem --region=us-east-1
# Here you don't need to copy it; the key material is automatically extracted with the query and redirected to a pem file
aws ec2 create-key-pair --key-name sample-kp2 --query 'KeyMaterial' --key-format=pem --region=us-east-1 --output text > sample-kp2.pem
# Same as above, but grabbing the region from the profile in ~/.aws/config we specified
aws ec2 create-key-pair --key-name sample-kp2 --query 'KeyMaterial' --key-format=pem --profile=ohio --output text > sample-kp2.pem

