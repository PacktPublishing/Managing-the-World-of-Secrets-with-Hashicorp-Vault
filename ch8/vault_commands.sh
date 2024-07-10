#!/bin/bash
# Enabling secrets engines
vault secrets enable aws
vault secrets enable -path=ssh-dev ssh

# Disabling secrets engines
vault secrets disable azure

# Moving a secrets engine path
vault secrets move aws aws/acc/

# Tuning a secrets engine
vault secrets tune -default-lease-ttl=20h -audit-non-hmac-request-keys=common_name -audit-non-hmac-response-keys=serial_number pki/

# Enabling KV secrets engine (Version 2)
vault secrets enable kv-v2
vault secrets enable -version=2 kv

# Creating and reading a secret in KV secrets engine
vault kv put secret/qa username="qa-tool" password="qa-pwd"
vault kv get secret/qa

# Patching a secret
vault kv patch secret/qa password="qa-2-new"

# Deleting a specific version of a secret
vault kv delete -mount=secret -versions=4 qa

# Undeleting a secret version
vault kv undelete -versions=4 secret/qa

# Destroying a secret version
vault kv destroy -versions=4 secret/qa

# Deleting metadata for a secret
vault kv metadata delete secret/qa

# Enabling KV secrets engine with specific path and lease settings
vault secrets enable -path=acc-prod -default-lease-ttl=7m -max-lease-ttl=14m kv

# Tuning an existing secrets engine
vault secrets tune -default-lease-ttl=4m aws/

# Writing and reading a secret in Cubbyhole secrets engine
vault write cubbyhole/topexec-reporting-app db-report-password=T0ps3cr6t982
vault read cubbyhole/topexec-reporting-app -format=json | jq -r '.data["db-report-password"]'

# Wrapping a secret
vault kv get -wrap-ttl=300 secret/qa
export WRAPPING_TOKEN="hvs.XXXXXXYYYYYY"
VAULT_TOKEN=$WRAPPING_TOKEN vault unwrap

# Creating a wrapping token
vault token create -wrap-ttl=540 -policy=awsiam

# Enabling database secrets engine
vault secrets enable database

# Configuring database connection
vault write database/config/mysql \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(localhost:3306)/" \
    allowed_roles="creds-reader,creds-writer" \
    username="root" \
    password="sup3rm1sqlp@ss0rd"

# Creating roles for database access
vault write database/roles/creds-reader \
    db_name=mysql \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT SELECT ON *.* TO '{{name}}'@'%';" \
    default_ttl="1h" \
    max_ttl="24h"

vault write database/roles/creds-writer \
    db_name=mysql \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT ALL ON *.* TO '{{name}}'@'%';" \
    default_ttl="1h" \
    max_ttl="24h"

# Creating policies for database roles
vault policy write creds-reader creds-reader.hcl
vault policy write creds-writer creds-writer.hcl

# Generating and using tokens for database access
vault token create –policy=reader
vault login <READER_token>
vault read database/creds/creds-reader

vault token create –policy=writer
vault login <WRITER_token>
vault read database/creds/creds-writer

# Enabling SSH secrets engine
vault secrets enable ssh

# Creating a role for SSH access
vault write ssh/roles/vaultadmin \
    key_type=otp \
    default_user=vsshuser \
    cidr_list=0.0.0.0/0

# Installing and configuring Vault SSH helper
#!/bin/bash
wget https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_386.zip
unzip vault-ssh-helper_0.2.1_linux_386.zip
mv vault-ssh-helper /usr/local/bin
export VAULT_ADDR=http://localhost:8200/
rm vault-ssh-helper_0.2.1_linux_386.zip

# Restarting SSH service
systemctl restart ssh.service
systemctl status ssh.service

# Adding a user for SSH access
adduser vsshuser

# Verifying Vault SSH helper configuration
vault-ssh-helper -dev -verify-only -config=/etc/vault-ssh-helper.d/config.hcl

# Port forwarding setup (Example for VirtualBox)
VBoxManage modifyvm "VM name" --natpf1 "guestssh,tcp,,2222,,22"
