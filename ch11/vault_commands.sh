#!/bin/bash

# Install Jenkins
# On MacOS, execute the following command:
brew install jenkins

# Start Jenkins via brew services:
brew services start jenkins

# On Ubuntu (and other Debian flavors) this assumes you have Java installed
sudo apt update
sudo apt install jenkins –y

# Jenkins can be controlled in standard way with systemd
# adjusts firewall settings, if we happen to be behind one:
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo ufw allow 8080

# Unlocking Jenkins
cat /path/to/jenkins/secrets/initialAdminPassword

# On Windows with Chocolatey1
choco install jenkins

# Use some helper command to get the intial admin password and
# other useful information about Jenkins
# /InstallDir The directory where we installed Jenkins. The default
# C:\Program Files\Jenkins
# /Jenkins_Root data directory. Default is C:\ProgramData\Jenkins
# /Port The port to access Jenkins via. Defaults to 8080.
# /Java_Home The path to an installation of JRE 11, if not present in
# $env:JAVA_HOME.
# /Service_Username The account to run the Jenkins service as.
# Defaults to localsystem.
# /Service_Password The acco

# Vault: Create a secret
vault login <root_token>
vault kv put secret/devops/jenkinssecret

# Vault: Enable AppRole
vault auth enable approle

# Vault: Create and upload a policy
echo 'path "auth/approle/login" {
  capabilities = ["create", "read", "list"]
}
path "secret/devops/*" {
  capabilities = ["read", "list"]
}' > jenkins.hcl

vault policy write jenkins jenkins.hcl

# Vault: Create a Jenkins role and obtain credentials
vault write auth/approle/role/jenkins -policies=jenkins
vault read auth/approle/role/<role-name>/role-id
vault write -f auth/approle/role/<role-name>/secret-id

# Jenkins job: Add a build step
#!/bin/bash
echo $VAULT_PROVIDED_SECRET
echo $VAULT_PROVIDED_SECRET >> saved_secret_from_vault.txt

# Note: Remove the line that saves the secret to a file after testing
# echo $VAULT_PROVIDED_SECRET >> saved_secret_from_vault.txt

# Upload Nomad policy to read DB secrets
vault policy write nomad-read-db nomad-read-db.hcl

vault write auth/token/roles/nomad-orchestrator-role \ 
    allowed_policies="nomad-read-db" \ 
    orphan=true \ 
    period=6h   