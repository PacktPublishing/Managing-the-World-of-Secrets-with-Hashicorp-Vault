#!/bin/bash

# Replace placeholders like `<SHA256 Hex value of the plugin binary>`, 
# `<your_plugin_name>`, and `<vault-server>` with actual values relevant to your environment.

#!/bin/bash

# Step 1: Register and enable the first plug-in version
vault plugin register \
    -sha256=<SHA256 Hex value of the plugin binary> \
    secret \
    <your_plugin_name>

vault secrets enable <your_plugin_name>

# Step 2: Register the second plug-in version
vault plugin register \
    -sha256=<SHA256 Hex value of the plugin binary> \
    -command=<your_plugin_name>-1.0.1 \
    -version=v1.0.1 \
    secret \
    <your_plugin_name>

# Step 3: Set the cluster’s pinned version to the new plug-in version
vault write sys/plugins/pins/secret/<your_plugin_name> \
    version=v1.0.1

# Step 4: Trigger plug-ins reload
vault plugin reload -type=secret \
    -plugin=<your_plugin_name> -scope=global

# Check plugin versions
vault plugin list secret

# Example CI/CD commands for automating upgrade and downgrade
# Upgrade plugin using Vault API
curl -X POST \
    --data '{"plugin_name": "<your_plugin_name>", "version": "v1.0.1"}' \
    http://<vault-server>/v1/sys/plugins/reload/backend

# Or execute CLI commands over SSH
ssh user@<vault-server> 'vault plugin register -sha256=<SHA256 Hex value> secret <your_plugin_name>'


