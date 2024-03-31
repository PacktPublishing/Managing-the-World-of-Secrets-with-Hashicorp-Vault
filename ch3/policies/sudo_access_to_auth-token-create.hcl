# Grant sudo capability to auth/token/create
path "auth/token/create" {
    capabilities = [ "sudo", "create", "read", "update", "delete", "list" ]
}