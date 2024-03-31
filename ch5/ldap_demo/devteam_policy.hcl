# Allow devteam members to do anything with secrets in this path
path "secret/data/devteam" {
    capabilities = [ "create", "read", "update", "delete" ]
}