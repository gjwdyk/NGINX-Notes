#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

cd $HOME;sudo curl -fksSL -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/KeyCloak/KeyCloakEnvironmentVariable.sh;sudo chmod 777 $HOME/KeyCloakEnvironmentVariable.sh;sudo chown $(id -u):$(id -g) $HOME/KeyCloakEnvironmentVariable.sh;source $HOME/KeyCloakEnvironmentVariable.sh

# Ability to configure a complex organization in such a linear method as below is of-course impossible in real-world.
# However, as this script aims only for demo and learning purposes, it will do at the moment.

declare -a KeyCloakRealmName
declare -a KeyCloakClientName
declare -a ServiceHostPort
declare -a KeyCloakRedirectURI
declare -a KeyCloakRoleName
declare -a KeyCloakMemberUserName
declare -a KeyCloakMemberPassword

KeyCloakRealmName[0]="master"
KeyCloakClientName[0]="operator-client"
ServiceHostPort[0]="192.168.123.102:43210"
KeyCloakRedirectURI[0]="http://$ServiceHostPort[0]/_codexch"
KeyCloakRoleName[0]="operator-role"
KeyCloakMemberUserName[0]="operator"
KeyCloakMemberPassword[0]="operator"

KeyCloakRealmName[1]="master"
KeyCloakClientName[1]="member-client"
ServiceHostPort[1]="192.168.123.102:8080"
KeyCloakRedirectURI[1]="http://$ServiceHostPort[1]/_codexch"
KeyCloakRoleName[1]="member-role"
KeyCloakMemberUserName[1]="member"
KeyCloakMemberPassword[1]="member"

KeyCloakRealmName[2]="master"
KeyCloakClientName[2]="subscriber-client"
ServiceHostPort[2]="192.168.123.102:80"
KeyCloakRedirectURI[2]="http://$ServiceHostPort[2]/_codexch"
KeyCloakRoleName[2]="subscriber-role"
KeyCloakMemberUserName[2]="subscriber"
KeyCloakMemberPassword[2]="subscriber"

max_counter=2

for counter in $(seq 0 $max_counter) ; do
 # Obtain Token
 export KeyCloakToken=$(curl -fksSL --request POST $KeyCloakAPIBaseURL/realms/${KeyCloakRealmName[$counter]}/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "username=$KEYCLOAK_ADMIN" --data-urlencode "password=$KEYCLOAK_ADMIN_PASSWORD" --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
 echo "KeyCloakToken = $KeyCloakToken"
 # Create Client
 curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/clients --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "{ \"clientId\": \"${KeyCloakClientName[$counter]}\", \"protocol\": \"openid-connect\", \"publicClient\": false, \"authorizationServicesEnabled\": true, \"serviceAccountsEnabled\": true, \"redirectUris\": [ \"${KeyCloakRedirectURI[$counter]}\" ] }" | jq
 # Obtain Client ID
 export KeyCloakClientID=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq ".[] | select(.clientId==\"${KeyCloakClientName[$counter]}\")" | jq -r '.id')
 echo "KeyCloakClientID = $KeyCloakClientID"
 # Obtain Client Secret
 export KeyCloakClientSecret=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/clients/$KeyCloakClientID/client-secret --header "Authorization: Bearer $KeyCloakToken" | jq -r '.value')
 echo "KeyCloakClientSecret = $KeyCloakClientSecret"
 # Create Role
 curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "{ \"name\": \"${KeyCloakRoleName[$counter]}\" }" | jq
 # Obtain Role ID
 export KeyCloakRoleID=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" | jq ".[] | select(.name==\"${KeyCloakRoleName[$counter]}\")" | jq -r '.id')
 echo "KeyCloakRoleID = $KeyCloakRoleID"
 # Create User
 curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/users --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "{ \"username\": \"${KeyCloakMemberUserName[$counter]}\", \"credentials\": [ { \"type\": \"password\", \"value\": \"${KeyCloakMemberPassword[$counter]}\", \"temporary\": false } ] }" | jq
 # Obtain User ID
 export KeyCloakUserID=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/users --header "Authorization: Bearer $KeyCloakToken" | jq ".[] | select(.username==\"${KeyCloakMemberUserName[$counter]}\")" | jq -r '.id')
 echo "KeyCloakUserID = $KeyCloakUserID"
 # Create Client-Role Mapping
 curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/users/$KeyCloakUserID/role-mappings/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "[ { \"id\": \"$KeyCloakRoleID\", \"name\": \"${KeyCloakRoleName[$counter]}\" } ]" | jq
 # Obtain Client-Role Mapping
 curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/${KeyCloakRealmName[$counter]}/users/$KeyCloakUserID/role-mappings/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" | jq
done



#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝



#╔═════════╗
#║   End   ║
#╚═════════╝