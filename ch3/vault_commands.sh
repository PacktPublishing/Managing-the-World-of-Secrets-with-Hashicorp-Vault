#!/bin/bash

# Export vars
export VAULT_SKIP_VERIFY=true
# export VAULT_CACERT="/opt/vault/tls/tls.crt"
# The moment you set the env var, crazy things are happening
# 1. Does not want to execute without sudo for uploading Vault policies
# 2. Even with sudo it says: failed to verify certificate: x509: certificate signed by unknown authority
# 3. Potentially there is a conflict with tls_cert_file = "/opt/vault/tls/selfsigned.crt" in vault.hcl 
# under a listener.
# export VAULT_CACERT="/opt/vault/tls/selfsigned.crt"
export VAULT_NAMESPACE=admin

# "systemctl start vault.service" runs this:
# ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl
/usr/bin/vault server -config=/etc/vault.d/vault.hcl


vault operator init

vault token create -policy=policy1 -policy=policy2

### CREATE FIRST TOKEN ###
#1. Create policy
vault policy write corp1-dept1-and-2 policy1.hcl

#2. Create a token bound to this policy without TTL
vault token create -policy=corp1-dept1-and-2                                       
# Key                  Value
# ---                  -----
# token                hvs.CAESIFYcHyrAFjmghn3-kEHqqHDJM-Ord-uK0aIOm4pQYxHLGh4KHGh2cy5LQzhVQlpSbUROZEk4QXZ1UnV5eEY5S1E
# token_accessor       ylx6S1PyvlUsbNhoAeGUBI3D
# token_duration       768h
# token_renewable      true
# token_policies       ["corp1-dept1-and-2" "default"]
# identity_policies    []
# policies             ["corp1-dept1-and-2" "default"]

#2.1 Optional - if VAULT_TOKEN is set, you will need to unset it in order to login with a specific token
unset VAULT_TOKEN

#3. Log in with parent token
vault login hvs.CAESIFYcHyrAFjmghn3-kEHqqHDJM-Ord-uK0aIOm4pQYxHLGh4KHGh2cy5LQzhVQlpSbUROZEk4QXZ1UnV5eEY5S1E


### CREATE CHILD TOKENS ###
#1. Create a policy
vault policy write token_creation token_creation_policy.hcl

#2. Create a parent token
vault token create -policy=token_creation -ttl=10m
# Key                  Value
# ---                  -----
# token                hvs.CAESINUgv_2wPT8fbQZG9kHcZk2ZC1oTl0HXwuDhQEkxlcT3Gh4KHGh2cy5PU0h5NGJGOFRjbUI3ZHBlT2pZRzVxZ3A
# token_accessor       jNGZKa60DWBsFS3FkIrnGjFE
# token_duration       10m
# token_renewable      true
# token_policies       ["default" "token_creation"]
# identity_policies    []
# policies             ["default" "token_creation"]

#3. Log in with parent token (make sure VAULT_TOKEN is unset)
vault login hvs.CAESINUgv_2wPT8fbQZG9kHcZk2ZC1oTl0HXwuDhQEkxlcT3Gh4KHGh2cy5PU0h5NGJGOFRjbUI3ZHBlT2pZRzVxZ3A
# Key                  Value
# ---                  -----
# token                hvs.CAESINUgv_2wPT8fbQZG9kHcZk2ZC1oTl0HXwuDhQEkxlcT3Gh4KHGh2cy5PU0h5NGJGOFRjbUI3ZHBlT2pZRzVxZ3A
# token_accessor       jNGZKa60DWBsFS3FkIrnGjFE
# token_duration       9m15s
# token_renewable      true
# token_policies       ["default" "token_creation"]
# identity_policies    []
# policies             ["default" "token_creation"]

#4. Create child token
vault token create -ttl=20m
# Key                  Value
# ---                  -----
# token                hvs.CAESILbBXzsfib_wzJi_wtY2PuxFi6jG8KJSmS-KAz9-lC2RGh4KHGh2cy5sRjN2NTNjVnpTWkt0bUxNT3d5Z2pjMk4
# token_accessor       0dAZGROEHkYDYVtPTUNlEAW8
# token_duration       20m
# token_renewable      true
# token_policies       ["default" "token_creation"]
# identity_policies    []
# policies             ["default" "token_creation"]

#5. Login with child tooken
vault login hvs.CAESILbBXzsfib_wzJi_wtY2PuxFi6jG8KJSmS-KAz9-lC2RGh4KHGh2cy5sRjN2NTNjVnpTWkt0bUxNT3d5Z2pjMk4
# Key                  Value
# ---                  -----
# token                hvs.CAESILbBXzsfib_wzJi_wtY2PuxFi6jG8KJSmS-KAz9-lC2RGh4KHGh2cy5sRjN2NTNjVnpTWkt0bUxNT3d5Z2pjMk4
# token_accessor       0dAZGROEHkYDYVtPTUNlEAW8
# token_duration       18m34s
# token_renewable      true
# token_policies       ["default" "token_creation"]
# identity_policies    []
# policies             ["default" "token_creation"]

#5. Look up child token
vault token lookup
# Key                 Value
# ---                 -----
# accessor            0dAZGROEHkYDYVtPTUNlEAW8
# creation_time       1707049586
# creation_ttl        20m
# display_name        token
# entity_id           n/a
# expire_time         2024-02-04T14:46:26.750647279+02:00
# explicit_max_ttl    0s
# id                  hvs.CAESILbBXzsfib_wzJi_wtY2PuxFi6jG8KJSmS-KAz9-lC2RGh4KHGh2cy5sRjN2NTNjVnpTWkt0bUxNT3d5Z2pjMk4
# issue_time          2024-02-04T14:26:26.75065045+02:00
# meta                <nil>
# num_uses            0
# orphan              false
# path                auth/token/create
# policies            [default token_creation]
# renewable           true
# ttl                 17m6s
# type                service

vault token revoke hvs.CAESINUgv_2wPT8fbQZG9kHcZk2ZC1oTl0HXwuDhQEkxlcT3Gh4KHGh2cy5PU0h5NGJGOFRjbUI3ZHBlT2pZRzVxZ3A

### FIND TOKENS WITH SAME POLICIES - TODO: extract the "root" into a variable that you can pass in the the jq query
vault list -format json auth/token/accessors | \ 
    jq -r .[] | xargs -I '{}' vault token lookup -format json -accessor '{}' | \ 
    jq -r 'select(.data.policies | any(. == "root"))'

### Create Orphan Tokens ###
# API - if you specify an "id" the way have done before, the "id" value becomes the actual token;
# if you don't a long hash will be generated and returned in the response, but not when you use the accessor to lookup the token
  curl -X 'POST' \
  'https://127.0.0.1:8200/v1/auth/token/create-orphan' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -H 'X-Vault-Token: hvs.kZkb3Xqx7iNPSMcE1xuQyiM1' \
  -d '{
  "display_name": "orphan-1",
  "entity_alias": "",
  "explicit_max_ttl": "2h",
  "id": "orphan-1_2024-01-27_14-12-53",
  "meta": {},
  "no_default_policy": true,
  "no_parent": true,
  "num_uses": 6,
  "period": "20m",
  "policies": [
    "token_creation"
  ],
  "renewable": true,
  "ttl": "30m",
  "type": "service"
}'
# This will return an accessor - seeunder the "auth" key in the JSON below
{
  "request_id": "692cfe53-edb8-a048-8eef-569912e1cbc5",
  "lease_id": "",
  "renewable": false,
  "lease_duration": 0,
  "data": null,
  "wrap_info": null,
  "warnings": [
    "Supplying a custom ID for the token uses the weaker SHA1 hashing instead of the more secure SHA2-256 HMAC for token obfuscation. SHA1 hashed tokens on the wire leads to less secure lookups."
  ],
  "auth": {
    "client_token": "orphan-1_2024-01-27_14-12-53",
    "accessor": "XcFFLRGJivUxQSYTgjSqOWCV",
    "policies": [
      "token_creation"
    ],
    "token_policies": [
      "token_creation"
    ],
    "metadata": {},
    "lease_duration": 1200,
    "renewable": true,
    "entity_id": "",
    "token_type": "service",
    "orphan": true,
    "mfa_requirement": null,
    "num_uses": 6
  }
}

# Now we can look up the token using the accessor
vault token lookup -accessor XcFFLRGJivUxQSYTgjSqOWCV                        
# Key                 Value
# ---                 -----
# accessor            XcFFLRGJivUxQSYTgjSqOWCV
# creation_time       1707406344
# creation_ttl        20m
# display_name        token-orphan-1
# entity_id           n/a
# expire_time         2024-02-08T17:52:24.763541281+02:00
# explicit_max_ttl    2h
# id                  n/a
# issue_time          2024-02-08T17:32:24.763545137+02:00
# meta                map[]
# num_uses            6
# orphan              true
# path                auth/token/create-orphan
# period              20m
# policies            [token_creation]
# renewable           true
# ttl                 11m51s
# type                service


# API - passing the reqeust payload (aka body) from a separate file
curl --header "X-Vault-Token: hvs.kZkb3Xqx7iNPSMcE1xuQyiM1" \
    --request POST \
    --data payloads/@orphan-token.json \
    -k \
    https://127.0.0.1:8200/v1/auth/token/create-orphan

# List the accessors to ID the token and look it up, if needed
vault list auth/token/accessors

# Creating an orphan token via the CLI
vault token create -orphan -policy my-policy -ttl 30m

# Create a token that has sudo access to auth/token/create
vault token create -policy=sudo-access_to_auth-token-create                       
# Key                  Value
# ---                  -----
# token                hvs.CAESIH7zfPvIV1x1pWptHPiMK8ZiFQ2i-nxR8rQ1NvsAgWCfGh4KHGh2cy5xNmdvQkIySVZhRDdubTROMWpHbVlYejY
# token_accessor       RvXV7sGRPYkegp9eYCRZY2uG
# token_duration       768h
# token_renewable      true
# token_policies       ["default" "sudo-access_to_auth-token-create"]
# identity_policies    []
# policies             ["default" "sudo-access_to_auth-token-create"]

# Create user to log in and create a token
vault write auth/userpass/users/tokenman1 \
    password=pwd123 \
    policies=admins

# Login with that user
vault login -method=userpass username=tokenman1 password=pwd123                                          
# WARNING! The VAULT_TOKEN environment variable is set! The value of this
# variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
# update its value accordingly.

# Success! You are now authenticated. The token information displayed below
# is already stored in the token helper. You do NOT need to run "vault login"
# again. Future Vault requests will automatically use this token.

# Key                    Value
# ---                    -----
# token                  hvs.CAESIIW65Hb0d3x67UeuEmaAMUmegSfwNK3Uunv-WN_ZSsiUGh4KHGh2cy5MSEZsTEFqakZSRzB0MlJTd0ZBb2YwUHo
# token_accessor         UUlC4fNGEddPv7hxhwDx7Tj8
# token_duration         768h
# token_renewable        true
# token_policies         ["admins" "default"]
# identity_policies      []
# policies               ["admins" "default"]
# token_meta_username    tokenman1

# Log in as root again - use the root token
vault login hvs.kZkb3Xqx7iNPSMcE1xuQyiM1 

# Look up the token with its accessor - orphan=true
vault token lookup -accessor UUlC4fNGEddPv7hxhwDx7Tj8
# Key                 Value
# ---                 -----
# accessor            UUlC4fNGEddPv7hxhwDx7Tj8
# creation_time       1707663214
# creation_ttl        768h
# display_name        userpass-tokenman1
# entity_id           63a8866e-2d67-4db8-88d5-adfbb618db86
# expire_time         2024-03-14T16:53:34.109146876+02:00
# explicit_max_ttl    0s
# id                  n/a
# issue_time          2024-02-11T16:53:34.109151244+02:00
# meta                map[username:tokenman1]
# num_uses            0
# orphan              true
# path                auth/userpass/login/tokenman1
# policies            [admins default]
# renewable           true
# ttl                 767h55m31s
# type                service

# You may have to unset VAULT_TOKEN, if needed for later operations
unset VAULT_TOKEN
