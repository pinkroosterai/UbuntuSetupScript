#!/bin/bash

# Function to validate FQDN
function validate_fqdn() {
    local fqdn="$1"

    if [[ "$fqdn" =~ ^([a-zA-Z0-9][-a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$ ]]; then
        return 0  # Valid FQDN
    else
        return 1  # Invalid FQDN
    fi
}

# Prompt user for hostname
read -p "Enter the new hostname (FQDN): " new_hostname

# Validate the entered hostname
if validate_fqdn "$new_hostname"; then
    echo "Changing hostname to $new_hostname..."

    # Change hostname temporarily
    sudo hostnamectl set-hostname "$new_hostname"

    # Update /etc/hosts
    sudo sed -i "s/127.0.1.1.*/127.0.1.1   $new_hostname/" /etc/hosts

    echo "Hostname changed successfully."

    # Reboot the system
    read -p "Reboot the system to apply changes? (y/n): " confirm_reboot
    if [[ "$confirm_reboot" =~ ^[Yy]$ ]]; then
        echo "Rebooting..."
        sudo reboot
    else
        echo "Reboot skipped. Please reboot manually to apply the changes."
    fi
else
    echo "Error: '$new_hostname' is not a valid FQDN."
    exit 1
fi
