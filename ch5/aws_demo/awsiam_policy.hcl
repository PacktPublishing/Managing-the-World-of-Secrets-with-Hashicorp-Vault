# AWS Auth policy
path "secret/awsauth/*" {
    capabilities = ["read", "list"]
}
