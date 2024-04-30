
cluster_addr =  "https://127.0.0.1:8201"
api_addr =  "https://127.0.0.1:8200"

listener "tcp" {
    address = "127.0.0.1:8200"
    tls_disable = 1
}



storage "raft" {
    node_id = "raft-1"
    path = "/raft/data/path"
}