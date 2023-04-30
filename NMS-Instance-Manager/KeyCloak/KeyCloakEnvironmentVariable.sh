#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh

# Reference of URL to install and configure:
# https://www.keycloak.org/getting-started/getting-started-zip
export KEYCLOAK_ADMIN="admin"
export KEYCLOAK_ADMIN_PASSWORD="admin"

export KeyCloakHostPort="$OICServer:$OICPort"
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
