#!/bin/bash -xe

echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

# Reference of URL to install and configure:
# https://www.keycloak.org/getting-started/getting-started-zip
cd $HOME;sudo curl -fksSL -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/KeyCloak/KeyCloakEnvironmentVariable.sh;sudo chmod 777 $HOME/KeyCloakEnvironmentVariable.sh;sudo chown $(id -u):$(id -g) $HOME/KeyCloakEnvironmentVariable.sh;source $HOME/KeyCloakEnvironmentVariable.sh

/root/keycloak/bin/kc.sh start-dev --log="console,file" &
echo "$!" | tee /root/keycloak/KeyCloakPID
chmod 666 /root/keycloak/KeyCloakPID



#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

java -version

echo "KeyCloak Admin's UserName = $KEYCLOAK_ADMIN"
echo "KeyCloak Admin's Password = $KEYCLOAK_ADMIN_PASSWORD"
cat /etc/crontab
echo "KeyCloakPID = $(cat /root/keycloak/KeyCloakPID)"
ps -ef | grep $(cat /root/keycloak/KeyCloakPID)

# Trying to wait until KeyCloak works
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ $(curl -fksSL --request POST http://localhost:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token') ] ; then
  echo "`date +%Y%m%d%H%M%S` KeyCloak is working."
  export KeyCloakToken=$(curl -fksSL --request POST http://localhost:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
  curl -fksSL --request GET http://localhost:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" | jq
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for KeyCloak to be working."
  sleep $Loop_Period
 fi
done

sudo cat /root/keycloak/data/log/keycloak.log



#╔═════════╗
#║   End   ║
#╚═════════╝
