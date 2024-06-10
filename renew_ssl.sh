#!/bin/bash

# Chemin vers le répertoire sites-available de Nginx
SITES_AVAILABLE="/etc/nginx/sites-available"

# Chemin vers le répertoire où sont stockés les certificats
CERT_PATH="/etc/letsencrypt/live"

# Seuil de jours avant expiration pour déclencher le renouvellement
RENEW_DAYS=30

# Récupération de la liste des domaines à partir des fichiers de configuration de Nginx
DOMAINS=($(grep -hroP 'server_name\s+\K[^;]+' $SITES_AVAILABLE | tr ' ' '\n' | sort -u))

# Boucle sur chaque domaine
for DOMAIN in "${DOMAINS[@]}"; do
    echo "Vérification du certificat pour $DOMAIN..."
    
    # Vérifie si le chemin du certificat existe
    if [ -f "$CERT_PATH/$DOMAIN/fullchain.pem" ]; then
        # Obtention de la date d'expiration du certificat
        EXPIRE_DATE=$(openssl x509 -enddate -noout -in "$CERT_PATH/$DOMAIN/fullchain.pem" | cut -d= -f2)
        EXPIRE_DATE_SECONDS=$(date -d "$EXPIRE_DATE" +%s)
        CURRENT_DATE_SECONDS=$(date +%s)
        
        # Calcul du nombre de jours avant expiration
        DAYS_LEFT=$(( ($EXPIRE_DATE_SECONDS - $CURRENT_DATE_SECONDS) / 86400 ))
        
        echo "Il reste $DAYS_LEFT jours avant l'expiration du certificat pour $DOMAIN."
        
        # Vérification si le renouvellement est nécessaire
        if [ "$DAYS_LEFT" -le "$RENEW_DAYS" ]; then
            echo "Renouvellement nécessaire pour $DOMAIN."
            # Commande de renouvellement de certbot
            certbot renew --cert-name "$DOMAIN" --quiet
        else
            echo "Le certificat pour $DOMAIN est valide pour plus de $RENEW_DAYS jours. Aucun renouvellement nécessaire."
        fi
    else
        echo "Aucun certificat trouvé pour $DOMAIN."
    fi
done