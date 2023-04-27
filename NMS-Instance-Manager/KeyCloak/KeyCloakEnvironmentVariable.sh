#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

# Reference of URL to install and configure:
# https://www.keycloak.org/getting-started/getting-started-zip
export KEYCLOAK_ADMIN="admin"
export KEYCLOAK_ADMIN_PASSWORD="admin"

export KeyCloakHostPort="192.168.123.203:8080"
export KeyCloakAPIBaseURL="http://$KeyCloakHostPort"



#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

echo "KEYCLOAK_ADMIN = $KEYCLOAK_ADMIN"
echo "KEYCLOAK_ADMIN_PASSWORD = $KEYCLOAK_ADMIN_PASSWORD"

echo "KeyCloakHostPort = $KeyCloakHostPort"
echo "KeyCloakAPIBaseURL = $KeyCloakAPIBaseURL"



#╔═════════╗
#║   End   ║
#╚═════════╝
