#!/bin/bash

# Function to check if Touch ID is already enabled for sudo
is_touchid_enabled() {
    # Check if the line 'auth sufficient pam_tid.so' is present in /etc/pam.d/sudo_local
    grep -q 'auth\s\+sufficient\s\+pam_tid.so' /etc/pam.d/sudo_local
}

# Check if the sudo_local file exists and is already configured for Touch ID
if [ -f /etc/pam.d/sudo_local ] && is_touchid_enabled; then
    echo "Touch ID authentication is already enabled for sudo."
    exit 0
fi

# Check if the sudo_local.template file exists
if [ ! -f /etc/pam.d/sudo_local.template ]; then
    echo "The sudo_local.template file does not exist. Exiting."
    exit 1
fi

# Enable Touch ID for sudo by uncommenting the pam_tid.so line in the sudo_local file
echo "Enabling Touch ID for sudo..."
# Remove the comment (uncomment the line) in the template and write it to sudo_local
sudo sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local > /dev/null

# Check if the sudo_local file was successfully updated
if is_touchid_enabled; then
    echo "Touch ID has been successfully enabled for sudo."
else
    echo "Failed to enable Touch ID for sudo."
    exit 1
fi
