#!/bin/bash

# Chapter 4
# Create another user - this time under auth/userpass2/users
vault write auth/userpass/users/johnd \
    password=jd123 \
    policies=admins,token_creation

# Using AppRole
# Enable AppRole auth method
sudo vault auth enable -tls-skip-verify approle

# Create a policy
vault policy write approle policies/approle.hcl

# Create a role
vault write -tls-skip-verify auth/approle/role/cloud-storage-manager secret_id_ttl="2160h" token_ttl="360h" policies="approle"

# Generate role_id - notice the dash, not underscore in role-id at the end
vault read auth/approle/role/cloud-storage-manager/role-id

# Generate secret_id - notice the dash, not underscore in secret-id at the end
vault write -f auth/approle/role/cloud-storage-manager/secret-id

vault write auth/approle/login \
    role_id=612ae193-c584-8ae1-92ea-9c2f45487e04 \
    secret_id=0afad939-0f25-477c-b038-83131d488081

