#!/bin/bash

# Update Jenkins version
jenkins_update() {
    echo "Updating Jenkins to the latest version..."
    # Command to update Jenkins
    sudo apt-get update
    sudo apt-get upgrade jenkins -y
}

# Update vulnerable plugins
update_plugins() {
    echo "Updating Jenkins plugins..."
    # Command to update plugins
    sudo jenkins-plugin-cli --plugins configuration-as-code git workflow-aggregator
}

# Enable CSRF protection
enable_csrf_protection() {
    echo "Enabling CSRF protection..."
    # Command to enable CSRF protection
    sudo sed -i 's/CRSF\.PROTECTION=false/CRSF.PROTECTION=true/g' /etc/jenkins/config.xml
}

# Configure advanced authentication
configure_authentication() {
    echo "Configuring advanced authentication..."
    # Commands to configure LDAP, SSO, or MFA
    sudo sed -i 's/AUTHENTICATION_METHOD=none/AUTHENTICATION_METHOD=ldap/g' /etc/jenkins/config.xml
}

# Enable matrix-based security
enable_matrix_security() {
    echo "Enabling matrix-based security..."
    # Command to enable matrix-based security
    sudo sed -i 's/MATRIX_SECURITY=false/MATRIX_SECURITY=true/g' /etc/jenkins/config.xml
}

# Remove unnecessary permissions
remove_permissions() {
    echo "Removing unnecessary permissions..."
    # Command to remove permissions
    sudo sed -i 's/AUTHENTICATED_USERS_FULL_ACCESS=true/AUTHENTICATED_USERS_FULL_ACCESS=false/g' /etc/jenkins/config.xml
}

# Do not run builds on built-in node
disable_built_in_node_builds() {
    echo "Disabling builds on built-in node..."
    # Command to disable builds on built-in node
    sudo sed -i 's/USE_BUILT_IN_NODE=true/USE_BUILT_IN_NODE=false/g' /etc/jenkins/config.xml
}

# Limit agent-to-master commands
limit_agent_commands() {
    echo "Limiting agent-to-master commands..."
    # Command to limit commands
    sudo sed -i 's/AGENT_MASTER_COMMANDS=true/AGENT_MASTER_COMMANDS=false/g' /etc/jenkins/config.xml
}

# Enable TLS encryption
enable_tls() {
    echo "Enabling TLS encryption..."
    # Commands to enable TLS
    sudo sed -i 's/TLS.ENABLED=false/TLS.ENABLED=true/g' /etc/jenkins/config.xml
}

# Disable SSHD port
disable_sshd() {
    echo "Disabling SSHD port..."
    # Command to disable SSHD
    sudo systemctl stop ssh
    sudo systemctl disable ssh
}

# Turn on Jenkins audit logs
enable_audit_logs() {
    echo "Enabling audit logs..."
    # Command to enable audit logs
    sudo sed -i 's/AUDIT_LOGS=false/AUDIT_LOGS=true/g' /etc/jenkins/config.xml
}

# Filter out unsafe environment variables
filter_env_vars() {
    echo "Filtering out unsafe environment variables..."
    # Command to filter environment variables
    sudo sed -i 's/ALLOW_UNSAFE_ENV_VARS=true/ALLOW_UNSAFE_ENV_VARS=false/g' /etc/jenkins/config.xml
}

# Enable markup formatter
enable_markup_formatter() {
    echo "Enabling markup formatter..."
    # Command to enable markup formatter
    sudo sed -i 's/MARKUP_FORMATTER=raw/MARKUP_FORMATTER=plainText/g' /etc/jenkins/config.xml
}

# Credentials binding and masking
mask_credentials() {
    echo "Masking credentials in Jenkins..."
    # Commands to mask credentials
    sudo sed -i 's/MASK_PASSWORDS=false/MASK_PASSWORDS=true/g' /etc/jenkins/config.xml
}

# Main script execution
main() {
    jenkins_update
    update_plugins
    enable_csrf_protection
    configure_authentication
    enable_matrix_security
    remove_permissions
    disable_built_in_node_builds
    limit_agent_commands
    enable_tls
    disable_sshd
    enable_audit_logs
    filter_env_vars
    enable_markup_formatter
    mask_credentials
    echo "Jenkins security hardening completed."
}

# Execute the main function
main
