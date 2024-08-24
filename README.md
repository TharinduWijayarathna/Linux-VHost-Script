# Apache Virtual Host Creation Script

## Overview

This script automates the creation of a new virtual host on an Apache web server, including SSL certificate generation using Certbot. It enables you to set up a new website with a specified domain name, document root, and IP address.

### Features
- Create a new Apache virtual host configuration.
- Set up an SSL certificate using Certbot.
- Redirect HTTP traffic to HTTPS.
- Automatically reload Apache to apply changes.

## Prerequisites
- **Apache**: Ensure Apache is installed on your server.
- **Certbot**: Install Certbot to manage SSL certificates.
- **Root Privileges**: The script needs to be run with root privileges.

## Usage

### Running the Script

```bash
sudo ./create_vhost.sh <domain_name> <web_root_directory> <ip_address>
```

### Example

```bash
sudo ./create_vhost.sh test.cp /var/www/test/test_app/public 127.0.1.105
```

