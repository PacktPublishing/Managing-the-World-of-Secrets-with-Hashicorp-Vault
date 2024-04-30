
# Cluster and API addresses - both needed for Raft to work
# TODO: replace the 172.31.11.139 with your host's IP
cluster_addr =  "https://172.31.11.139:8201"
api_addr =  "https://0.0.0.0:8200"

# Generic alternative to the above
cluster_addr =  "https://{{ GetPrivateIP }}:8201"
api_addr =  "https://{{ GetPrivateIP }}:8200"


# Comment out file storage and add this section
# TODO: replace the ip-172-31-11-139 with your hostname
storage "raft" {
    path = "/opt/vault.d/"
    node_id = "ip-172-31-11-139"   
}

# HTTPS listener - here added only cluster_address + its value; Vault uses to listen for cluster messages
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/opt/vault/tls/tls.crt"
  tls_key_file  = "/opt/vault/tls/tls.key"
}
