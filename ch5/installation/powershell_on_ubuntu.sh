#!/bin/bash

# Update your system
sudo apt-get update -y

# Only if you don't already have them
sudo apt-get install -y wget apt-transport-https software-properties-common

# Replace $VERSION_ID with YOUR Ubuntu OS version; in my case it is 22.04
# wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb

# Unpack
sudo dpkg -i packages-microsoft-prod.deb

# Update your packages one more time to sync everything for the Microsoft packages just unpacked above
sudo apt-get update -y

# PowerShell
sudo apt-get install -y powershell

# Test installation
pwsh
# Sample output:
# PowerShell 7.4.1
# PS /home/<your_machine_name>/Downloads/mustwatch> exit

