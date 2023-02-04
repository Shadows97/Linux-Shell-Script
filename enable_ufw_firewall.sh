#/bin/sh

echo "----------------- Step 1 – Set Up default UFW policies -----------------"

sudo ufw default allow outgoing

sudo ufw default deny incoming

echo "----------------- Step 2 – Open SSH TCP port 22 connections -----------------"

sudo ufw allow ssh

echo "----------------- Step 3 – Turn on firewall -----------------"

sudo ufw enable

echo "----------------- Step 3 – Open TCP port 80 and 443  -----------------"

sudo ufw allow 80/tcp comment 'accept Nginx'

sudo ufw allow 443/tcp comment 'accept HTTPS connections'

