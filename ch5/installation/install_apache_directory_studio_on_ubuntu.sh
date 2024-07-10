# Notes:
# 1. ADS requres Java
# 2. Tested with JDK 11
# 3. The user and group entries need to be created manually you have the steps both here in the comments below
# and in the book, chapter 5 (toward the end under the LDAP auth method demo section)

# Update and upgrade your system
sudo apt updatey
sudo apt upgradey

# Install wget, if NOT installed
sudo apt-get install wgety

# Install default JDK in the case of Ubuntu, at the time of writing the book, this is OpenJDK 11
sudo apt install default-jdky
javaversion
# Sample output:
# openjdk version "11.0.22" 2024-01-16
# OpenJDK Runtime Environment (build 11.0.22+7-post-Ubuntu-0ubuntu222.04.1)
# OpenJDK 64-Bit Server VM (build 11.0.22+7-post-Ubuntu-0ubuntu222.04.1, mixed mode, sharing)

# Also add the following instructions to ~/.zshrc to surivive reboots and run source ~/.zshrc after this script exits
export JAVA_HOME=/usr/bin/java

wget https://dlcdn.apache.org/directory/studio/2.0.0.v20210717-M17/ApacheDirectoryStudio-2.0.0.v20210717-M17-linux.gtk.x86_64.tar.gz
sleep 2
mkdir ads2000

# Extract the archive by removing the top level folder, but preserving the rest of the file hierarchy
# tar hierarchy: /component1/component2/componentX/file1.txt, etc.
tarxzf ApacheDirectoryStudio-2.0.0.v20210717-M17-linux.gtk.x86_64.tar.gzC ads2000-strip-component=1
sleep 2
cd ads2000 && ./ApacheDirectoryStudio
