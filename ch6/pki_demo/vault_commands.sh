#!/bin/bash

# Enable PKI secrets engine
vault secrets enable pki

# Tune it for 5
vault secrets tune -max-lease-ttl=87600h pki 

# Generate Root CA certificate
vault write -field=certificate pki/root/generate/internal \ 
    common_name="<your_org.com>" \
    ttl=87600h > Root_CA_cert.crt

# Expose two endpoints
# - one for issuing certificates and
# - one for the Certificate Revocation List (CRL) distribution point
vault write pki/config/urls \ 
    issuing_certificates="$VAULT_ADDR/v1/pki/ca" \ 
    crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

# Expose the PKI engine on another path for the Intermediate (Issuing) CA
vault secrets enable -path_pki_int pki

# Tune for 3 eyars
vault secrets tune -max-lease-ttl=26280h pki

# Sign the CSR with the Root CA's private key
vault write -format=json pki_int/intermediate/generate/internal \ 
    common_name="<your_org.com> Intermediate Authority" | 
    | jq -r '.data.csr' > pki_intermediate.csr

# Generate Intermediate CA certificate
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \ 
    format=pem_bundle ttl="43800h" \ 
    | jq -r '.data.certificate' > intermediate.cert.pem

# Configure the Intermedia CA's certificate in Vault
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem 

# Create a role for subdomains
vault write pki_int/roles/mysite-dot-com \ 
    allowed_domains="<your_org.com>" \
    allowed_subdomains=true \ 
    max_ttl="720h"

# Get a certificate from Vault - CLI
vault write pki_int/issue/<your_org_name> common_name="test.<your_org.com>" ttl="24h"

# Get a certificate from Vault - API
curl --header "X-Vault-Token: $VAULT_TOKEN" \ 
    --request POST \
    --data '{"common_name": "test.<your_org.com>", ttl="24h"}' \ 
    $VAULT_ADDR/v1/pki_int/issue/mysite-dot-com | jq

# Remove a certificate - you need its serial number for that to work
vault write pki_int/revoke \ 
    serial_number="0e:5b:ef:cc:87:48:d2:ca:d0:a5:eb ..."

# Periodically, you may also wish to remove a certificate
vault write pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true