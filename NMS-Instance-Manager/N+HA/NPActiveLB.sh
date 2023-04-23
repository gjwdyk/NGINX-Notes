#!/bin/bash -xe

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EditVariable.sh;sudo chmod 777 $HOME/EditVariable.sh

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BInstall/NPInstall.sh;sudo chmod 777 $HOME/NPInstall.sh;/bin/bash $HOME/NPInstall.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/LBnginx.conf;sudo chmod 666 $HOME/LBnginx.conf;/bin/bash $HOME/EditVariable.sh $HOME/LBnginx.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/LBnginx.conf /etc/nginx/nginx.conf;sudo nginx -t;sudo nginx -s reload
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/LBdefault.conf;sudo chmod 666 $HOME/LBdefault.conf;/bin/bash $HOME/EditVariable.sh $HOME/LBdefault.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/LBdefault.conf /etc/nginx/conf.d/default.conf;sudo nginx -t;sudo nginx -s reload

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/NPActiveHA.sh;sudo chmod 777 $HOME/NPActiveHA.sh;/bin/bash $HOME/NPActiveHA.sh



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


