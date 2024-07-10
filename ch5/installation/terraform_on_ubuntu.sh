# wgetO- https://apt.releases.hashicorp.com/gpg | sudo gpg-dearmoro /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_releasecs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list 2>&1

sudo apt update
sudo apt install terraformy
terraform version

# At the end of the output you should see something similar to the following:
# Terraform v1.7.4
# on linux_amd64
