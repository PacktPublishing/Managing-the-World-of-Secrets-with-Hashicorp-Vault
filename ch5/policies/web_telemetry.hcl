# Ability to:
# Add (create) metrics for servers that were not initially recorded
# List metrics secrets 
# Read secrets
path "sys/webserver/telemetry*" {
    capabilities = ["create", "list", "read"]
}

