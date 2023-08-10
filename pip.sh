#!/bin/bash

# Prompt for server details
read -p "Enter server IP address or hostname: " server_ip
read -p "Enter SSH port (default is 22): " ssh_port
ssh_port=${ssh_port:-22}

# Install required packages
sudo apt update
sudo apt install -y apache2 ufw

# Secure SSH
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i "s/#Port 22/Port $ssh_port/" /etc/ssh/sshd_config
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
sudo ufw allow "$ssh_port/tcp"  # SSH
sudo ufw allow 'Apache'  # Allow Apache (if installed)

# Display server details
echo "Server setup completed"
echo "Server IP: $server_ip"
echo "SSH Port: $ssh_port"

