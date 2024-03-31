#!/bin/bash

export VAULT_ADDR="https://localhost:8200"
export VAULT_SKIP_VERIFY=true
# export VAULT_CACERT="/opt/vault/tls/tls.crt"

export KEY1=jsvbLkqwO0zBPZX5jdVRLjywZsKgNJFaIuxcarf18GW+
export KEY2=gJiN/dnitTBk2gbGZgldOmZc99yrJPxm9nhu6lwBM5Ga
export KEY3=DNy/oK6x2G5VR44Qz+RjUQ9GClEdJeFqsBKiiae5VPrC

vault operator unseal $KEY1
vault operator unseal $KEY2 
vault operator unseal $KEY3