#!/bin/bash

# HCL Code for Vault Policies
cat <<EOF > policy.hcl
path "secret/accounting/databases/readonly/*" {
    capabilities = ["list", "read"]
}

path "secret/dev/team-1/*" {
    capabilities = ["create", "update", "read"]
}
EOF

# Write the policy to Vault
vault policy write my-policy policy.hcl

# Get a KV secret
vault kv get -mount=secret my-secret

# Enable the KV secrets engine version 2
vault secrets enable -version=2 kv

# Sample curl request to interact with Vault API
curl \
 -H "X-Vault-Token: f3b09679-3001-009d-2b80-9c306ab81aa6" \
 -H "X-Vault-Namespace: ns1/ns2/" \
 -X GET \
 http://127.0.0.1:8200/v1/secret/foo

# Authenticate to Vault via Curl using Username & Password method
curl \
    --request POST \
    --data @payload.json \
    http://127.0.0.1:8200/v1/auth/userpass/login/gsmith

# Sample payload for user authentication
cat <<EOF > payload.json
{
  "password": "g0sm1th827$#",
  "token_policies": ["admin", "default"],
  "token_bound_cidrs": ["127.0.0.1/32", "129.150.0.0/16"]
}
EOF

# Read an existing user
curl \
    --header "X-Vault-Token: <your_vault_token>" \
    http://127.0.0.1:8200/v1/auth/userpass/users/gsmith

# Read a KV secret via Curl
curl \
    --header "X-Vault-Token: ..." \
    https://127.0.0.1:8200/v1/secret/data/reportdb-creds?version=2

# Create a policy for a group of engineers
cat <<EOF > team-eng-policy.hcl
path "secret/data/team/eng" {
  capabilities = [ "create", "read", "update", "delete"]
}
EOF

vault policy write team-eng team-eng-policy.hcl

# Create an entity and save the entity ID
vault write -format=json identity/entity name="bob-smith" policies="base" \
     metadata=organization="ACME Inc." \
     metadata=team="QA" \
     | jq -r ".data.id" > entity_id.txt

# Create a group and assign the entity to it
vault write identity/group name="engineers" \
     policies="team-eng" \
     member_entity_ids=$(cat entity_id.txt) \
     metadata=team="Engineering" \
     metadata=region="North America"

# Request to create a key using the Transit engine
curl \
    --header "X-Vault-Token: <current_vault_token>" \
    --request POST \
    --data @payload.json \
    http://127.0.0.1:8200/v1/transit/keys/db-key

# Sample payload for creating a key
cat <<EOF > payload.json
{
  "type": "rsa-4096",
  "derived": true
}
EOF

# Encrypt data using the Transit engine
curl \
    --header "X-Vault-Token: ..." \
    --request POST \
    --data @payload.json \
    http://127.0.0.1:8200/v1/transit/encrypt/db-key

# Decrypt data using the Transit engine
curl \
    --header "X-Vault-Token: ..." \
    --request POST \
    --data @payload.json \
    http://127.0.0.1:8200/v1/transit/decrypt/db-key

# Import a key for the Transit engine
curl \
    --header "X-Vault-Token: ..." \
    --request POST \
    --data @payload.json \
    http://127.0.0.1:8200/v1/transit/keys/s3-key/import

# Sample payload for importing a key
cat <<EOF > payload.json
{
  "type": "aes256-gcm96",
  "ciphertext": "..."
}
EOF
