#!/bin/bash -xe

echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

cd $HOME;sudo curl -k -L -o $HOME/.ssh/id_rsa --retry 333 https://raw.githubusercontent.com/gjwdyk/PublicKeys/main/SShKeyPair/RSA/id_rsa;sudo chmod 600 $HOME/.ssh/id_rsa;sudo chown $(id -u):$(id -g) $HOME/.ssh/id_rsa
cd $HOME;sudo curl -k -L -o $HOME/.ssh/id_rsa.pub --retry 333 https://raw.githubusercontent.com/gjwdyk/PublicKeys/main/SShKeyPair/RSA/id_rsa.pub;sudo chmod 644 $HOME/.ssh/id_rsa.pub;sudo chown $(id -u):$(id -g) $HOME/.ssh/id_rsa.pub
cd $HOME;sudo curl -k -L -o $HOME/.ssh/authorized_keys --retry 333 https://raw.githubusercontent.com/gjwdyk/PublicKeys/main/SShKeyPair/RSA/id_rsa.pub;sudo chmod 600 $HOME/.ssh/authorized_keys;sudo chown $(id -u):$(id -g) $HOME/.ssh/authorized_keys

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt update -y
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get update -y
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt install -y jq

echo "As of now, the available Java versions are :"
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
apt-cache --names-only search 'openjdk-[0-9]*-(jre|jdk)' | sort -t '-' -k 2 -n
export LatestHeadlessJDK=$(apt-cache --names-only search 'openjdk-[0-9]*-jdk-headless' | sort -t '-' -k 2 -n | tail -1 | egrep -o 'openjdk-[0-9]*-jdk-headless')

echo "Installing $LatestHeadlessJDK ."
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt install -y $LatestHeadlessJDK

# Reference of URL to download installation file:
# https://www.keycloak.org/downloads

echo "Downloading KeyCloak Installation File ."
# curl -k -L -O --retry 333 https://github.com/keycloak/keycloak/releases/download/21.0.2/keycloak-21.0.2.tar.gz
# sudo tar -xvzf keycloak-21.0.2.tar.gz
# sudo mv keycloak-21.0.2/ /root/keycloak/
curl -k -L -O --retry 333 https://github.com/keycloak/keycloak/releases/download/21.1.0/keycloak-21.1.0.tar.gz
sudo tar -xvzf keycloak-21.1.0.tar.gz
sudo mv keycloak-21.1.0/ /root/keycloak/

sudo curl -k -L -o /root/keycloak/StartKeyCloak.sh --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/KeyCloak/StartKeyCloak.sh;sudo chmod 777 /root/keycloak/StartKeyCloak.sh;sudo /bin/bash /root/keycloak/StartKeyCloak.sh
echo "@reboot         root         sudo /bin/bash /root/keycloak/StartKeyCloak.sh" | sudo tee -a /etc/crontab

sudo curl -k -L -o /root/keycloak/KeyCloakConfigure.sh --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/KeyCloak/KeyCloakConfigure.sh;sudo chmod 777 /root/keycloak/KeyCloakConfigure.sh;sudo /bin/bash /root/keycloak/KeyCloakConfigure.sh



#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

java -version

echo "KeyCloak Admin's UserName = $KEYCLOAK_ADMIN"
echo "KeyCloak Admin's Password = $KEYCLOAK_ADMIN_PASSWORD"
cat /etc/crontab
echo "KeyCloakPID = $(sudo cat /root/keycloak/KeyCloakPID)"
ps -ef | grep $(sudo cat /root/keycloak/KeyCloakPID)

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
