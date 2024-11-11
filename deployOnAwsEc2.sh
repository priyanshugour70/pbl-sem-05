#!/bin/bash

# Update package lists and install Nginx
echo "Updating system and installing Nginx..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install nginx -y

# Remove the default Nginx HTML files and copy your website files
echo "Deploying website files..."
sudo rm -rf /var/www/html/*
sudo mkdir -p /var/www/html

# Copy all files and directories from pbl-sem-05 to /var/www/html
sudo cp -r ~/pbl-sem-05/* /var/www/html/

# Set proper permissions
echo "Setting permissions..."
sudo chmod -R 755 /var/www/html
sudo chown -R www-data:www-data /var/www/html

# Configure Nginx to serve the website
echo "Configuring Nginx..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOL
server {
    listen 80;
    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Restart Nginx to apply changes
echo "Restarting Nginx..."
sudo systemctl restart nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

echo "Deployment complete! Your website should now be accessible on this EC2 instance's public IP."
