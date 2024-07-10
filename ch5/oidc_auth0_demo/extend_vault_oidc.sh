#!/bin/bash

export VAULT_TOKEN=hvs.fOVY0485s6137HK3PSNXKa4J
export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true

vault policy write admin admin_policy.hcl

vault write auth/oidc/role/auth0-demo groups_claim="https://example.com/roles"

# Save the ID of the group attached to the amdin policy
GID=$(vault writeformat=json identity/group name="auth0-admin-group" policies="admin" \ 
    type="external" metadata=organization="Auth0 Users Org" | jqr .data.id)

# Create alias bound to the OIDC authentication method
vault write identity/group-alias name="admin" \
    mount_accessor=$(vault auth listformat=json | jqr '."oidc/".accessor') \
    canonical_id="${GID}"

# sudo ./extend_vault_oidc.sh
# Success! Uploaded policy: admin
# Success! Data written to: auth/oidc/role/auth0-demo
# Key             Value
#--            ----
# canonical_id    d85c03b8-a0d2-e125-88bc-8531e5f8ec02
# id              761e48fc-279c-28a3-1b01-b042891645b2
