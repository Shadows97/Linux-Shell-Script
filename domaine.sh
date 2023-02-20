#!/bin/bash

# Vérifier si l'utilisateur a exécuté le script en tant que superutilisateur (root)
if [ $(id -u) != 0 ]; then
    echo "Ce script doit être exécuté en tant que superutilisateur (root)"
    exit 1
fi

# Demander le nom de domaine
read -p "Entrez le nom de domaine: " domain_name

# Installer nginx et Certbot
apt update
apt install -y nginx
apt install -y certbot python3-certbot-nginx

# Créer un fichier de configuration nginx pour le site
cat << EOF > /etc/nginx/sites-available/$domain_name
server {
    listen 80;
    server_name $domain_name;
    location / {
        proxy_pass http://localhost:9000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Activer la configuration nginx pour le site
ln -s /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/

# Tester la configuration nginx
nginx -t

# Redémarrer nginx
systemctl restart nginx

# Obtenir un certificat SSL pour le nom de domaine avec Certbot
certbot --nginx -d $domain_name


# Créer un fichier de configuration nginx pour le site
cat << EOF > /etc/nginx/sites-available/$domain_name
server {
    listen 80;
    server_name $domain_name;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name $domain_name;

    ssl_certificate /etc/letsencrypt/live/$domain_name/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain_name/privkey.pem;

    location / {
        proxy_pass http://localhost:9000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Tester la configuration nginx
nginx -t

# Redémarrer nginx
systemctl restart nginx