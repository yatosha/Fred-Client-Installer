# Fred Client Installer Tool

## Description

Fred Client Installer Tool is a bash script developed by Yatosha Web Services for installing and configuring the Fred client on Ubuntu or Debian based systems. The Fred client is a tool used for managing domain registrations and related services.

## Features

- Automatically installs Python if not already installed
- Installs required dependencies
- Adds CZ.NIC keyring for Fred packages
- Prompts user for registration name and password
- Configures Fred client settings
- Allows user to provide certificate content and filename

## Compatibility

This script is compatible with Ubuntu and Debian based systems.

## Installation

To install the Fred Client Installer Tool, simply clone this repository and execute the `install.sh` script:

```bash
git clone https://github.com/YatoshaWebServices/fred-client-installer.git
cd fred-client-installer
./install.sh
