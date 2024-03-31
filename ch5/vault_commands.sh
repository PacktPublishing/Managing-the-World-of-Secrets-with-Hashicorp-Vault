#!/bin/bash

# Chapter 5

# Generate private and public keys
openssl genrsa -out jwt_private_key.pem 2048
openssl rsa -in jwt_private_key.pem -outform PEM -pubout -out jwt_public_key.pem

# Configure JWT auth method


# Create another user - this time under auth/userpass2/users
vault auth enable jwt
# or
vault auth enable oidc

# Write Policy
vault policy write webmetrics -<<EOF
path "sys/webserver/metrics*" {
capabilities = ["read", "list"]
}
EOF

# Write a JWT
vault write auth/jwt/login role=demo jwt=...


vault write auth/jwt/config \
    oidc_discovery_url="https://myco.auth0.com/" \
    oidc_client_id="m5i8bj3iofytj" \
    oidc_client_secret="f4ubv72nfiu23hnsj" \
    default_role="demo"

# JWT verification with JWT token validation
# - Authorizes JWTs with the given subject and audience claims
# - Gives it the webapps policy
# - Uses the given user/groups claims to set up Identity aliases
vault write auth/jwt/config \
   oidc_discovery_url="https://MYDOMAIN.eu.auth0.com/" \
   oidc_client_id="" \
   oidc_client_secret="" \

# Create named role
vault write auth/jwt/role/demo \
    allowed_redirect_uris="http://localhost:8250/oidc/callback" \
    bound_subject="r3qX9DljwFIWhsiqwFiu38209F10atW6@clients" \
    bound_audiences="https://vault.plugin.auth.jwt.test" \
    user_claim="https://vault/user" \
    groups_claim="https://vault/groups" \
    policies=webapps \
    ttl=1h


# Private key
openssl genrsa -out jwt_private_key.pem 2048

# Public key
openssl rsa -in jwt_private_key.pem -outform PEM -pubout -out jwt_public_key.pem

# Configure JWT auth method
vault write auth/jwt/config jwt_supported_algs=RS256 jwt_validation_pubkeys=@jwt_public_key.pem

# Create JWT role - this is for testing purposes, you can call it restapirole, or whatever suits your needs
vault write auth/jwt/role/jwt-role \
policies="webtelemetry" \
user_claim="sub" \
role_type="jwt" \
bound_audiences="jwtwebapp"

# Verify created role settings
vault read auth/jwt/role/jwt-role
# {
#     "aud": "jwtwebapp",
#     "name": "Thomas Paine",
#     "iat" : 1708955787,
#     "exp": 1711815237,
#     "sub": "sub"
# }


vault write auth/jwt/login role=jwt-role jwt=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJqd3R3ZWJhcHAiLCJuYW1lIjoiVGhvbWFzIFBhaW5lIiwiaWF0IjoxNzA4OTU1Nzg3LCJleHAiOjE3MTE4MTUyMzcsInN1YiI6InN1YiJ9.WLj07Vf5NFTY-hjaTmG4sIKWybPBeiE69J7NG2UwZ7yEpq8hcRLWqENul9dzR_3v0zdFbPNx4TYIbiLokaKAKTisAdXDzIpYp1HkL3k4bqNLay5MY4bEq59xIgOmJAlx-eUWWCMhU6SWi-GXp6riadWw0INe9IDONsdvGkv76vSkgjAXGsBvZ_QmBflEb4GQMEzJxyh2MyozKzw4PmfphDRItiMx9hcsP4aZDoRtMEKAPOzcvLv14yguk8N7dJUyBOetG3P5rQySbY8NhQDr0FnHNncfCJvj_elT_zRdqBorPOdn4uUcfnpJxTI6VW3mYGxtK-v-3NMyxQVvqPgWww

# Install Auth0 CLI
# Download binary
curl -sSfL https://raw.githubusercontent.com/auth0/auth0-cli/main/install.sh | sh -s -- -b .

# Make it available everywhere in the file system
sudo mv ./auth0 /usr/local/bin
auth0 -v

# Intialize Auth0 domain, client id, and client secret
source .env

# Create web app app in Auth0 - Vault will communicate with it during OIDC authentication
export CLIENTID_OF_WEB_APP=$(auth0 apps create \
  --name "Vault Communicator" \
  --description "Handles comms between Vault and Auth0" \
  --type regular \
  --reveal-secrets \
  --json | jq -r '. | {client_id: .client_id, client_secret: .client_secret}')

  echo $CLIENTID_OF_WEB_APP
# {
#   "client_id": "YEcN3CK4XcOA1tZvtVqBblLQuLznEM88",
#   "client_secret": "47qEZ-paSFnYzU-BkBnpUqHb1WkOZ1xCq21i5vjtMyOE3j7gxR6dwDELXUEL42By"
# }

# Delete Auth0 app
auth0 apps delete pQ6lVvxH1leUOGVIDACScVG4lcUyNVeV

# Add user and role - copy/paste manually in the Auth0 UI under the user's meta data
{
	"roles": ["admin"]
}

# AWS auth method demo
# Enable kv2 secrets engine, if not already enabled
vault secrets enable -path=secret kv-v2

# Create a secret
vault kv put secret/awsiamauth/config ttl=15m user=tester1 password=t3stp@assw0rd
# Read that secret
vault kv get secret/awsiamdauth/config
# Delete, if needed; you could just create another version by writing again with different valies
vault kv metadata delete secret/awsiamauth/config
vault kv metadata delete secret/awsiamauth

# Upload a corresponding policy
vault policy write awsiam awsiam_policy.hcl
# Check the policy is there
vault policy list
# Read it back
vault policy read awsiam

# Create AWS user with AdministratorAccess policy attached
aws iam create-user \
    --user-name vaultiam \
    --permissions-boundary arn:aws:iam::aws:policy/AdministratorAccess
# {
#     "User": {
#         "Path": "/",
#         "UserName": "vaultiam",
#         "UserId": "AIDATPLNME26PO2SL4GFD",
#         "Arn": "arn:aws:iam::239136941756:user/tester4",
#         "CreateDate": "2024-03-23T14:51:04Z", 
#         "PermissionsBoundary": {
#             "PermissionsBoundaryType": "Policy",
#             "PermissionsBoundaryArn": "arn:aws:iam::aws:policy/AdministratorAccess"
#         }
#     }
# }

aws iam create-access-key --user-name vaultiam
# {
#     "AccessKey": {
#         "UserName": "vaultiam",
#         "AccessKeyId": "AKIATPLNME26K225T64Q",
#         "Status": "Active",
#         "SecretAccessKey": "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",
#         "CreateDate": "2024-03-23T14:56:42Z"
#     }
# }

# Enable AWS auth method
vault auth enable aws

# Best Practice: on AWS, create a separate IAM user and generate access and secret keys
# Upload AWS credentials under the corresponding path
vault write auth/aws/config/client access_key=the_access_key secret_key=the_secret_key

# Create IAM policy - you will need the AWS CLI installed
aws iam create-policy --policy-name vault-awsiam-policy --policy-document file://vault_iam_policy.json
# {
#     "Policy": {
#         "PolicyName": "vault-awsiam-policy",
#         "PolicyId": "ANPATPLNME26BKSCCMAIE",
#         "Arn": "arn:aws:iam::239136941756:policy/vault-awsiam-policy",
#         "Path": "/",
#         "DefaultVersionId": "v1",
#         "AttachmentCount": 0,
#         "PermissionsBoundaryUsageCount": 0,
#         "IsAttachable": true,
#         "CreateDate": "2024-03-25T09:00:50Z",
#         "UpdateDate": "2024-03-25T09:00:50Z"
#     }
# }


# Create a role
aws iam create-role --role-name vault-aws-auth-role --assume-role-policy-document file://vault_aws_auth_role.json

# Attach the policy to the role
aws iam attach-role-policy --role-name vault-aws-auth-role --policy-arn arn:aws:iam::<aws_account_number>:policy/vault-awsiam-policy

# Attach policy to vaultiam user
aws iam attach-user-policy \
    --policy-arn arn:aws:iam::<account_id>:policy/vault-awsiam-policy \
    --user-name vaultiam

# Create corresponding Vault role
vault write auth/aws/role/awsiamauth-role \ 
    auth_type=iam \
    bound_iam_principal_arn="arn:aws:iam::<account_id>:user/vaultiam"
    policies=awsiam \
    ttl=72h

# Add custom header for extra security; pass it in with every login request
vault write auth/aws/config/client iam_server_id_header_value=vaultawsiam.example.com

# Modify role to allow any user to log in
vault write auth/aws/role/awsiamauth-role \ 
    auth_type=iam \
    bound_iam_principal_arn="arn:aws:iam::239136941756:*"
    policies=awsiam \
    ttl=72h

# Attempt to log in without overriding the default keys in ~/.aws/credentials
# If you followed best practices and configured the vaultiam user access and secret jeys in ~/.aws/credentials, this command will succeed
# Here, I delieberately left my AWS root keys in place to demonstrate the error.
vault login -method=aws header_value="vaultawsiam.example.com" role=awsiamauth-role

# Overriding the keys in ~/.aws/credentials
vault login -method=aws header_value="vaultawsiam.example.com" role=awsiamauth-role aws_access_key_id=AKIATPLNME26KNMQBPVO aws_secret_access_key=ElxtljFqzCikYzPjYrwyewav73zVFTWFRhwpAnnn

# LDAP demo
# Enable LDAP auth method
vault auth enable ldap

# Create a policy
vault policy write devteam devteam_policy.hcl

# Create a devstars Vault group
vault write auth/ldap/groups/devstars policies=devteam

# Configure Vault to talk to Apache Directory Studio LDAP server
# Make sure there are no spaces after the backslash at the end of every line
vault write auth/ldap/config \
url="ldap://example.com:10389" \
userattr="cn" \
userdn="cn=vaultadmin,ou=users,ou=system" \
groupdn="ou=groups,ou=system" \
groupfilter="(|(memberUid={{.Username}})(member={{.UserDN}})(uniqueMember={{.UserDN}}))" \
binddn="cn=vaultadmin,ou=users,ou=system" \
bindpass="vaultadmin" \
groupattr="uniqueMember" \
insecure_tls=true \
starttls=false

# Read the config back for verification purposees
vault read auth/ldap/config

# Create an LDAP server withing ADS
# 1. On the LDAP Servers tab, R-click > New > New Server
# 2. Expand the Apache Software Foundation node and select ApacheDS 2.0.0 and click Finish
# 3. Back on the LDAP Servers tab, select the server just created, and click the Run green icon or Ctrl+R 
# 4. Wait until the label under the State column will change to "Started"
# 5. Switch to the Connections tab - you should see an active connection. Select it.
# 6. In the LDAP Browser pane (just above the Connections tab), expand the DIT node

# Login with LDAP auth method
vault login -method=ldap username=vaultadmin


# LDAP Searches
# General search - return everything
ldapsearch -v -H ldap://example.com:10389 -x -D "uid=admin,ou=system" -w "secret" "(objectclass=*)" -b "ou=system"
