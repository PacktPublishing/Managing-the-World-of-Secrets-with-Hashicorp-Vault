#!/bin/bash

# Update your system
sudo apt-get updatey

# Only if you don't already have them
sudo apt-get instally wget apt-transport-https software-properties-common

# Replace $VERSION_ID with YOUR Ubuntu OS version; in my case it is 22.04
# wgetq https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
wgetq https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb

# Unpack
sudo dpkgi packages-microsoft-prod.deb

# Update your packages one more time to sync everything for the Microsoft packages just unpacked above
sudo apt-get updatey

# PowerShell
sudo apt-get instally powershell

# Test installation
pwsh
# Sample output:
# PowerShell 7.4.1
# PS /home/<your_machine_name>/Downloads/mustwatch> exit

