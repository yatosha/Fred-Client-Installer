#!/bin/bash

# Banner message
echo "##############################################"
echo "#                                            #"
echo "#   Fred Client Installer Tool by Yatosha    #"
echo "#          Web Services                      #"
echo "#                                            #"
echo "##############################################"
echo ""

# Check if OS is Ubuntu or Debian based
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
        echo "This script is only compatible with Ubuntu or Debian based systems."
        exit 1
    fi
else
    echo "Unable to determine the operating system. Exiting."
    exit 1
fi

# Function to install Python if not installed
install_python() {
    read -p "Python is required but not installed. Do you want to install it? (y/n): " install_py
    if [ "$install_py" = "y" ]; then
        apt install -y python
    else
        echo "Python is required for this script. Exiting."
        exit 1
    fi
}

# Check if Python is installed
if ! command -v python &>/dev/null; then
    install_python
fi

# Install dependencies
apt update
apt install -y ca-certificates curl gnupg lsb-release

# Add cznic keyring for fred packages and run update with the new source list
mkdir -p /usr/share/keyrings/
curl -o /usr/share/keyrings/cznic-archive-keyring.gpg https://archive.nic.cz/dists/cznic-archive-keyring.gpg

# Empty /etc/apt/sources.list.d/fred.list if it exists
if [ -f "/etc/apt/sources.list.d/fred.list" ]; then
    > /etc/apt/sources.list.d/fred.list
fi

cat << EOT >> /etc/apt/sources.list.d/fred.list
deb [signed-by=/usr/share/keyrings/cznic-archive-keyring.gpg arch=amd64] http://archive.nic.cz/next $(lsb_release -sc) main
EOT

apt update

# Install fred client
apt --assume-yes install fred-client

# Prompt user for REG-NAME and REG Password
read -p "Enter REG-NAME: " reg_name
read -s -p "Enter REG Password: " reg_password
echo

# Modify fred-client.conf
sed -i "s/username = REG-FRED_A/username = $reg_name/" /etc/fred/fred-client.conf
sed -i "s/password = passwd/password = $reg_password/" /etc/fred/fred-client.conf
sed -i "s/host = localhost/host = mtanzania.tznic.or.tz/" /etc/fred/fred-client.conf

# Prompt user for certificate content
echo "Please paste the certificate content below (CTRL+D to finish):"
cert_content=$(cat)

# Prompt user for certificate name
read -p "Enter certificate file name (without extension): " cert_name

# Check if certificate file already exists and empty it if it does
if [ -f "/usr/share/fred-client/ssl/$cert_name.pem" ]; then
    > "/usr/share/fred-client/ssl/$cert_name.pem"
fi

# Create certificate file with pasted content
echo "$cert_content" > "/usr/share/fred-client/ssl/$cert_name.pem"

# Update fred-client.conf with the correct certificate file name
sed -i "s/ssl_cert = %(dir)s\/test-cert.pem/ssl_cert = %(dir)s\/$cert_name.pem/" /etc/fred/fred-client.conf
sed -i "s/ssl_key = %(dir)s\/test-key.pem/ssl_key = %(dir)s\/$cert_name.pem/" /etc/fred/fred-client.conf

echo "Installation completed successfully."
echo "Tool Developed By Yatosha Web Services"
