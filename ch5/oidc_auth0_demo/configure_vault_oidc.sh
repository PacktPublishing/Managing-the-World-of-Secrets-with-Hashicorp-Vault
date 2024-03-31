#!/bin/bash


systemctl stop vault.service
set -e
source .env

sleep 4
systemctl start vault.service
sleep 4
sudo ../unseal_vault.sh
export VAULT_TOKEN=hvs.fOVY0485s6137HK3PSNXKa4J
export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true

vault policy write min min_policy.hcl

vault auth enable oidc

# Expose the OIDC method in the UI
vault auth tune -listing-visibility=unauth -description="Logging in with OIDC" oidc/

vault write auth/oidc/config \
    oidc_discovery_url="https://$AUTH0_DOMAIN/" \
    oidc_client_id="$AUTH0_CLIENT_ID" \
    oidc_client_secret="$AUTH0_CLIENT_SECRET" \
    default_role="auth0-demo"

vault write auth/oidc/role/auth0-demo \
    bound_audiences="$AUTH0_CLIENT_ID" \
    allowed_redirect_uris="https://localhost:8200/ui/vault/auth/oidc/oidc/callback" \
    allowed_redirect_uris="https://localhost:8250/oidc/callback" \
    user_claim="sub" \
    policies=min

# Check role, if needed - here we verify that role auth0-demo is listed
vault list auth/oidc/role
# Read the fole fields to verify the values are correct
vault read auth/oidc/role/auth0-demo
