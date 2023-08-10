#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y apache2 ufw

# Secure SSH
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Create user accounts and SSH keys
for i in {1..10}; do
    username="A453048220$(printf "%02d" "$i")"
    
    sudo adduser "$username" --gecos "User $i"
    
    sudo mkdir -p "/home/$username/.ssh"
    sudo ssh-keygen -t rsa -b 4096 -C "$username@example.com" -N "" -f "/home/$username/.ssh/id_rsa"
    sudo cp "/home/$username/.ssh/id_rsa.pub" "/home/$username/.ssh/authorized_keys"
    sudo chown -R "$username:$username" "/home/$username/.ssh"
done

# Configure firewall
sudo ufw enable
sudo ufw allow 2222/tcp  # SSH on port 2222
sudo ufw allow 'Apache'  # Allow Apache (if installed)

echo "Server setup completed"

