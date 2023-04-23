#!/bin/bash -xe

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BInstall/NPInstall.sh;sudo chmod 777 $HOME/NPInstall.sh;/bin/bash $HOME/NPInstall.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/NPStandByHA.sh;sudo chmod 777 $HOME/NPStandByHA.sh;/bin/bash $HOME/NPStandByHA.sh



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


