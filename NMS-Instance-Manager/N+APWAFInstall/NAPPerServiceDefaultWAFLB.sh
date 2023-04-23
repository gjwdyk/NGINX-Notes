#!/bin/bash -xe

#
# Below configurations are to be used with servers/applications built with :
# https://github.com/gjwdyk/NGINX-Notes/tree/main/NMS-Instance-Manager/K8sServer
#

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EditVariable.sh;sudo chmod 777 $HOME/EditVariable.sh

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFInstall/NAPWAFInstall.sh;sudo chmod 777 $HOME/NAPWAFInstall.sh;/bin/bash $HOME/NAPWAFInstall.sh

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFLB/PerServiceDefaultWAFLBnginx.conf;sudo chmod 666 $HOME/PerServiceDefaultWAFLBnginx.conf;/bin/bash $HOME/EditVariable.sh $HOME/PerServiceDefaultWAFLBnginx.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/PerServiceDefaultWAFLBnginx.conf /etc/nginx/nginx.conf;sudo nginx -t;sudo nginx -s reload
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFLB/PerServiceDefaultWAFLBdefault.conf;sudo chmod 666 $HOME/PerServiceDefaultWAFLBdefault.conf;/bin/bash $HOME/EditVariable.sh $HOME/PerServiceDefaultWAFLBdefault.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/PerServiceDefaultWAFLBdefault.conf /etc/nginx/conf.d/default.conf;sudo nginx -t;sudo nginx -s reload

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFLB/FavouriteLogo.ico;sudo chmod 666 $HOME/FavouriteLogo.ico;sudo mv $HOME/FavouriteLogo.ico /usr/share/nginx/html/favicon.ico



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


