# Outputs:

## endpoints = <<EOT

  NOTE: While Terraform's work is done, these instances need time to complete
        their own installation and configuration. Progress is reported within
        the log file `/var/log/tf-user-data.log` and reports 'Complete' when
        the instance is ready.

  ### vault_1 (3.84.129.6) | internal: (10.0.101.21)
    Initialized and unsealed.
    The root token creates a transit key that enables the other Vaults to auto-unseal.
    Does not join the High-Availability (HA) cluster.

  ### vault_2 (3.86.68.79) | internal: (10.0.101.22)
- Initialized and unsealed.
- The root token and recovery key is stored in /tmp/key.json.
- K/V-V2 secret engine enabled and secret stored.
- Leader of HA cluster
```sh
sshl ubuntu 3.86.68.79i ue1-vault-kp2.pem

# Root token:
sshl ubuntu 3.86.68.79i ue1-vault-kp2.pem "cat ~/root_token"
# Recovery key:
sshl ubuntu 3.86.68.79i ue1-vault-kp2.pem "cat ~/recovery_key"
```

  ### vault_3 (52.90.208.221) | internal: (10.0.101.23)
    Started
    You will join it to cluster started by vault_2
```sh
sshl ubuntu 52.90.208.221i ue1-vault-kp2.pem
```

  ### vault_4 (54.146.123.162) | internal: (10.0.101.24)
    Started
    You will join it to cluster started by vault_2
```sh
sshl ubuntu 54.146.123.162i ue1-vault-kp2.pem
```

EOT
