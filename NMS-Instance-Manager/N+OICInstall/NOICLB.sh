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
Loop_Period="9s"
while ( [ "$Loop" == "Yes" ] ) ; do
 if ( ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakStatus | egrep -o "^([0-9]{14} KeyCloak is Ready \.)$" ) ; then
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakAPIBaseURL | tee KeyCloakAPIBaseURL
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakRealmName0 | tee KeyCloakRealmName0
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientName0 | tee KeyCloakClientName0
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientSecret0 | egrep -o "^[a-zA-Z0-9]{32}$" | tee KeyCloakClientSecret0
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakRealmName1 | tee KeyCloakRealmName1
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientName1 | tee KeyCloakClientName1
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientSecret1 | egrep -o "^[a-zA-Z0-9]{32}$" | tee KeyCloakClientSecret1
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakRealmName2 | tee KeyCloakRealmName2
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientName2 | tee KeyCloakClientName2
  ssh -o StrictHostKeyChecking=no $OICServer sudo cat /root/KeyCloakClientSecret2 | egrep -o "^[a-zA-Z0-9]{32}$" | tee KeyCloakClientSecret2
  echo "`date +%Y%m%d%H%M%S` KeyCloak Server is Ready ."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` KeyCloak Server is NOT Ready ."
  sleep $Loop_Period
 fi
done
echo "`date +%Y%m%d%H%M%S` Out of Checking Loop for KeyCloak Server."

./nginx-openid-connect/configure.sh -h $DomainName3 -k request -i $(cat KeyCloakClientName2) -s $(cat KeyCloakClientSecret2) -x $(cat KeyCloakAPIBaseURL)/realms/$(cat KeyCloakRealmName2)/.well-known/openid-configuration
./nginx-openid-connect/configure.sh -h $DomainName2 -k request -i $(cat KeyCloakClientName1) -s $(cat KeyCloakClientSecret1) -x $(cat KeyCloakAPIBaseURL)/realms/$(cat KeyCloakRealmName1)/.well-known/openid-configuration
./nginx-openid-connect/configure.sh -h $DomainName1 -k request -i $(cat KeyCloakClientName0) -s $(cat KeyCloakClientSecret0) -x $(cat KeyCloakAPIBaseURL)/realms/$(cat KeyCloakRealmName0)/.well-known/openid-configuration

sudo cp $HOME/nginx-openid-connect/openid_connect.js /etc/nginx/conf.d/ ; sudo chmod 666 /etc/nginx/conf.d/openid_connect.js
sudo cp $HOME/nginx-openid-connect/openid_connect.server_conf /etc/nginx/conf.d/ ; sudo chmod 666 /etc/nginx/conf.d/openid_connect.server_conf
sudo cp $HOME/nginx-openid-connect/openid_connect_configuration.conf /etc/nginx/conf.d/ ; sudo chmod 666 /etc/nginx/conf.d/openid_connect_configuration.conf

sudo sed -n '/^\ *resolver\ *[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\ *\;\ */p' /etc/nginx/conf.d/openid_connect.server_conf
sudo sed -i 's#resolver\ *[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\ *\;#resolver   127.0.0.53 ;#g' /etc/nginx/conf.d/openid_connect.server_conf
sudo sed -n '/^\ *resolver\ *[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\ *\;\ */p' /etc/nginx/conf.d/openid_connect.server_conf

sudo sed -n '/^\ *'"$DomainName1"'\ *0\;$/p' /etc/nginx/conf.d/openid_connect_configuration.conf
sudo sed -i 's#'"$DomainName1"'\ *0\;#'"$DomainName1"'   '"$(cat KeyCloakClientSecret0)"' ;#g' /etc/nginx/conf.d/openid_connect_configuration.conf
sudo sed -nE '/^\ *'"$DomainName1"'\ *[a-zA-Z0-9]{32}\ *\;\ *$/p' /etc/nginx/conf.d/openid_connect_configuration.conf

sudo sed -n '/^\ *'"$DomainName2"'\ *0\;$/p' /etc/nginx/conf.d/openid_connect_configuration.conf
sudo sed -i 's#'"$DomainName2"'\ *0\;#'"$DomainName2"'   '"$(cat KeyCloakClientSecret1)"' ;#g' /etc/nginx/conf.d/openid_connect_configuration.conf
sudo sed -nE '/^\ *'"$DomainName2"'\ *[a-zA-Z0-9]{32}\ *\;\ *$/p' /etc/nginx/conf.d/openid_connect_configuration.conf

sudo sed -n '/^\ *'"$DomainName3"'\ *0\;$/p' /etc/nginx/conf.d/openid_connect_configuration.conf
sudo sed -i 's#'"$DomainName3"'\ *0\;#'"$DomainName3"'   '"$(cat KeyCloakClientSecret2)"' ;#g' /etc/nginx/conf.d/openid_connect_configuration.conf
sudo sed -nE '/^\ *'"$DomainName3"'\ *[a-zA-Z0-9]{32}\ *\;\ *$/p' /etc/nginx/conf.d/openid_connect_configuration.conf



if (sudo nginx -t 2>&1 | egrep "syntax is ok") && (sudo nginx -t 2>&1 | egrep "test is successful") ; then sudo nginx -s reload ; echo "NGINX ReLoaded." ; else "Error in NGINX Configuration." ; fi



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


