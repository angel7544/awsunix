#!/bin/bash

# Loop to add users and create shared folder in each user's home directory
for ((i=1; i<=150; i++)); do
    username="A45304822$(printf "%03d" "$i")"
    
    # Create the user
    sudo useradd -m "$username"

    # Create the shared folder in user's home directory
    sudo -u "$username" mkdir "/home/$username/shared"

    # Set group ownership and permissions for the shared folder
    sudo chown "$username:sharedgroup" "/home/$username/shared"
    sudo chmod 770 "/home/$username/shared"
    
    echo "Shared folder created for user '$username'"
done

echo "Setup completed: Shared folders created for all users"

