path "identity/*" {
    capabilities = ["read", "list"]
}

path "sys/policies/*" {
    capabilities = ["read", "list"]
}

path "secret/*" {
    capabilities = ["list", "create", "read", "update", "delete"]
}