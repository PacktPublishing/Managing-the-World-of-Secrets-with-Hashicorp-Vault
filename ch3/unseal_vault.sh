#!/bin/bash

export VAULT_ADDR="https://localhost:8200"
export VAULT_SKIP_VERIFY=true
# export VAULT_CACERT="/opt/vault/tls/tls.crt"

export KEY1=uWmvVapafbDl5Q/yZJHaWsc3PVoE+W/5krvjVA+8B/Qs
export KEY2=/vqOWwVddj9/Ytcvl+z8nIYQTPt88Xa6YFLI7+ztuKx6
export KEY3=SvDq8cxiUbg2Ky3upC9UhO4aWQJ1rkS98iSr5XosiHjK

vault operator unseal $KEY1
vault operator unseal $KEY2 
vault operator unseal $KEY3