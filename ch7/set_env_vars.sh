#!/bin/bash

export VAULT_SKIP_VERIFY=true
export VAULT_ADDR="https://127.0.0.1:8200"

# Replace with your current root token
export VAULT_CACERT=/opt/vault/tls/root_2024_ca.crt