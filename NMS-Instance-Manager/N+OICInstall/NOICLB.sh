#!/bin/bash -xe

#
# Below configurations are to be used with servers/applications built with :
# https://github.com/gjwdyk/NGINX-Notes/tree/main/NMS-Instance-Manager/K8sServer
#

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/KeyCloak/KeyCloakEnvironmentVariable.sh;sudo chmod 777 $HOME/KeyCloakEnvironmentVariable.sh;source $HOME/KeyCloakEnvironmentVariable.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EditVariable.sh;sudo chmod 777 $HOME/EditVariable.sh

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BOICInstall/NPOICInstall.sh;sudo chmod 777 $HOME/NPOICInstall.sh;/bin/bash $HOME/NPOICInstall.sh

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BOICLB/OICLBnginx.conf;sudo chmod 666 $HOME/OICLBnginx.conf;/bin/bash $HOME/EditVariable.sh $HOME/OICLBnginx.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/OICLBnginx.conf /etc/nginx/nginx.conf
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BOICLB/OICLBdefault.conf;sudo chmod 666 $HOME/OICLBdefault.conf;/bin/bash $HOME/EditVariable.sh $HOME/OICLBdefault.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/OICLBdefault.conf /etc/nginx/conf.d/default.conf

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/Image/FavouriteLogo.ico;sudo chmod 666 $HOME/FavouriteLogo.ico;sudo mv $HOME/FavouriteLogo.ico /usr/share/nginx/html/favicon.ico



cd $HOME;sudo curl -k -L -o $HOME/.ssh/id_rsa --retry 333 https://raw.githubusercontent.com/gjwdyk/PublicKeys/main/SShKeyPair/RSA/id_rsa;sudo chmod 600 $HOME/.ssh/id_rsa;sudo chown $(id -u):$(id -g) $HOME/.ssh/id_rsa
cd $HOME;sudo curl -k -L -o $HOME/.ssh/id_rsa.pub --retry 333 https://raw.githubusercontent.com/gjwdyk/PublicKeys/main/SShKeyPair/RSA/id_rsa.pub;sudo chmod 644 $HOME/.ssh/id_rsa.pub;sudo chown $(id -u):$(id -g) $HOME/.ssh/id_rsa.pub
cd $HOME;sudo curl -k -L -o $HOME/.ssh/authorized_keys --retry 333 https://raw.githubusercontent.com/gjwdyk/PublicKeys/main/SShKeyPair/RSA/id_rsa.pub;sudo chmod 600 $HOME/.ssh/authorized_keys;sudo chown $(id -u):$(id -g) $HOME/.ssh/authorized_keys

Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if ( ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakStatus | egrep -o "^([0-9]{14} KeyCloak is Ready \.)$" ) ; then
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakAPIBaseURL | tee KeyCloakAPIBaseURL
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakRealmName0 | tee KeyCloakRealmName0
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientName0 | tee KeyCloakClientName0
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientSecret0 | egrep -o "^[a-zA-Z0-9]{32}$" | tee KeyCloakClientSecret0
  echo "`date +%Y%m%d%H%M%S` KeyCloak Server is Ready ."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` KeyCloak Server is NOT Ready ."
  sleep $Loop_Period
 fi
done
echo "`date +%Y%m%d%H%M%S` Out of Checking Loop for KeyCloak Server."

./nginx-openid-connect/configure.sh -h $Worker1 -k request -i $(cat KeyCloakClientName0) -s $(cat KeyCloakClientSecret0) -x $(cat KeyCloakAPIBaseURL)/realms/$(cat KeyCloakRealmName0)/.well-known/openid-configuration


sudo nginx -t;sudo nginx -s reload

#╔══════════╗
#║   Test   ║
#╚══════════╝

journalctl -u nginx.service -b --no-pager
ps axu | grep nginx
nginx -V
sudo cat /var/log/nginx/error.log



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


