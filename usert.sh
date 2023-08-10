#!/bin/bash

# Function to generate usernames
generate_username() {
    prefix="$1"
    length="$2"
    random_number=$(printf "%03d" $(shuf -i 001-010 -n 1))  # Generates a random number between 1 and 150
    username="${prefix}${random_number}"
    echo "$username"
}

# Function to generate passwords
generate_password() {
    length="$1"
    password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$length" | head -n 1)
    echo "$password"
}

# List of prefixes and the desired length
prefixes=("A45304822")
username_length=12
password_length=5

# Generate 150 usernames and passwords
for i in {001..010}; do
    prefix_index=$(( RANDOM % ${#prefixes[@]} ))
    prefix="${prefixes[$prefix_index]}"
    
    username=$(generate_username "$prefix" "$username_length")
    password=$(generate_password "$password_length")
    
    # Create user with generated password
    sudo useradd -m "$username"
    echo "$username:$password" | sudo chpasswd
    echo "User '$username' created with password '$password'"
done
