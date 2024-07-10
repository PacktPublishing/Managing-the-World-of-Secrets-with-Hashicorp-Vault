#!/bin/bash

# Put a key value in Vault and prompt for the key
vault kv put <target/path> key=-

# Put a key value in Vault using data from a JSON file
vault kv put <target/path> @secretkey.json

# Ignore Vault commands in shell history
export HISTIGNORE="&:vault*"

### Exposed Metrics in Vault ###
# Audit log request failure
vault.audit.log_request_failure

# Audit log response failure
vault.audit.log_response_failure

# Count of identity entities created per namespace
vault.identity.entity.creation

# Total number of identity entities currently stored
vault.identity.num_entities

# Standby echo request failures
vault.ha.rpc.client.echo.errors

# Standby request forwarding failures
vault.ha.rpc.client.forward.errors
