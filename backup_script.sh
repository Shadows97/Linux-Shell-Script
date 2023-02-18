#!/bin/bash

# Variables pour PostgreSQL
POSTGRES_CONTAINER_NAME="postgres-container"
POSTGRES_DB_NAME="my_postgres_db"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="mysecretpassword"

# Variables pour MySQL
MYSQL_CONTAINER_NAME="mysql-container"
MYSQL_DB_NAME="my_mysql_db"
MYSQL_USER="root"
MYSQL_PASSWORD="mysecretpassword"

# Variables pour les backups
BACKUP_DIR="/path/to/backup/directory"
DATE=$(date +"%Y-%m-%d")

# Backup PostgreSQL
POSTGRES_BACKUP_FILENAME="${POSTGRES_DB_NAME}_${DATE}.sql"
docker exec ${POSTGRES_CONTAINER_NAME} pg_dump -U ${POSTGRES_USER} -d ${POSTGRES_DB_NAME} -f /backup/${POSTGRES_BACKUP_FILENAME}
docker cp ${POSTGRES_CONTAINER_NAME}:/backup/${POSTGRES_BACKUP_FILENAME} ${BACKUP_DIR}

# Backup MySQL
MYSQL_BACKUP_FILENAME="${MYSQL_DB_NAME}_${DATE}.sql"
docker exec ${MYSQL_CONTAINER_NAME} mysqldump -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DB_NAME} > /backup/${MYSQL_BACKUP_FILENAME}
docker cp ${MYSQL_CONTAINER_NAME}:/backup/${MYSQL_BACKUP_FILENAME} ${BACKUP_DIR}
