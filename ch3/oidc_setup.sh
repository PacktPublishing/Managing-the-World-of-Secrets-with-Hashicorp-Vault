#!/bin/bash


##############################################
### Part 1 Confgure Vault Authentication ###
##############################################
vault policy write  oidc_policy policies/oidc_prod.hcl
vault auth enable userpass


vault policy write oidc_read_authz_endpoint policies/oidc_read_authz_endpoint.hcl
# OR inline
vault policy write oidc_read_authz_endpoint << EOF
path "identity/oidc/provider/my-provider/authorize" {
capabilities = [ "read" ]
}
EOF

vault write auth/userpass/users/sample_oidc_end-user \
    password="password" \
    token_policies="oidc-auth" \
    token_ttl="1h"


#######################################################
### Part 2 Create Vault Identity Entity and Group ###
#######################################################
# 1. Create entity
vault write identity/entity \
    name="sample_oidc_end-user" \
    metadata="email=vault@hashicorp.com" \
    metadata="phone_number=617-549-7872" \
    disabled=false
# Output:
# Key        Value
#--       ----
# aliases    <nil>
# id         6b269c83-eacf-48a2-c557-2fcbfb0ce79b
# name       sample_oidc_end-user

# 2. Store entity "id" in a var
ENTITY_ID=$(vault readfield=id identity/entity/name/sample_oidc_end-user)
# echo $ENTITY_ID
# Output note that "id" was already listed in the output above after creating the entity:
# 6b269c83-eacf-48a2-c557-2fcbfb0ce79b

# 3. Create a group for the OIDC clients; make sample_oidc_end-user a member of the group
vault write identity/group \
    name="oidc_clients" \
    member_entity_ids="$ENTITY_ID"
# Output:
# Key     Value
#--    ----
# id      677a2451-1306-551e-3136-97eb8d4f6533
# name    oidc_clients

GROUP_ID=$(vault readfield=id identity/group/name/oidc_clients)
# echo $GROUP_ID:
# Output:
# 677a2451-1306-551e-3136-97eb8d4f6533

# 4. Create an entity alias maps an entity to client of an authentication method
# [in this case userpass auth method; the client of this auth method is the sample_oidc_end-user end-user we created before]. 
# This mapping requires the entity ID and the authentication accessor ID.
USERPASS_ACCESSOR=$(vault auth listdetailedformat json | jqr '.["userpass/"].accessor')
# echo $USERPASS_ACCESSOR
# Output:
# auth_userpass_4baa88fa