#!/bin/bash -xe

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EditVariable.sh;sudo chmod 777 $HOME/EditVariable.sh

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BInstall/NPInstall.sh;sudo chmod 777 $HOME/NPInstall.sh;/bin/bash $HOME/NPInstall.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/LBnginx.conf;sudo chmod 666 $HOME/LBnginx.conf;/bin/bash $HOME/EditVariable.sh $HOME/LBnginx.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/LBnginx.conf /etc/nginx/nginx.conf;sudo nginx -t;sudo nginx -s reload
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/LBdefault.conf;sudo chmod 666 $HOME/LBdefault.conf;/bin/bash $HOME/EditVariable.sh $HOME/LBdefault.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/LBdefault.conf /etc/nginx/conf.d/default.conf;sudo nginx -t;sudo nginx -s reload

# Two quick succession calls to the tServer script often result in second call returns empty string.
#
# queryResult="printf \"q\n\" | nc $Master1 12345 | grep -E \"^[a-zA-Z0-9]{30}$\""
# echo "$queryResult"
# Loop="Yes"
# LoopWaitPeriod="22s"
# while ( [ "$Loop" == "Yes" ] ) ; do
#  if ( eval "$queryResult" | grep -E "^[a-zA-Z0-9]{30}$" ) ; then         # first call to tServer
#   eval "$queryResult" | sudo tee $HOME/initialPassword                   # second call to tServer
#   echo "`date +%Y%m%d%H%M%S` `cat $HOME/initialPassword`"
#   Loop="No"
#  else
#   echo "`date +%Y%m%d%H%M%S` NMS Instance Manager node is NOT Ready . Sleep for $LoopWaitPeriod ."
#   sleep $LoopWaitPeriod
#   queryResult="printf \"q\n\" | nc $Master1 12345 | grep -E \"^[a-zA-Z0-9]{30}$\""
#  fi
# done

queryResult="printf \"q\n\" | nc $Master1 12345 | grep -E \"^[a-zA-Z0-9]{30}$\""
echo "$queryResult"
Loop="Yes"
LoopWaitPeriod="22s"
while ( [ "$Loop" == "Yes" ] ) ; do
 eval "$queryResult" | sudo tee $HOME/initialPassword
 echo "`date +%Y%m%d%H%M%S` queryResult : `cat $HOME/initialPassword`"
 if ( echo "`cat $HOME/initialPassword`" | grep -E "^[a-zA-Z0-9]{30}$" ) ; then
  echo "`date +%Y%m%d%H%M%S` initialPassword : `cat $HOME/initialPassword`"
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` NMS Instance Manager node is NOT Ready . Sleep for $LoopWaitPeriod ."
  sudo rm -f $HOME/initialPassword
  sleep $LoopWaitPeriod
  queryResult="printf \"q\n\" | nc $Master1 12345 | grep -E \"^[a-zA-Z0-9]{30}$\""
 fi
done

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NIM2-Agent/NIM2AgentInstall.sh;sudo chmod 777 $HOME/NIM2AgentInstall.sh;/bin/bash $HOME/NIM2AgentInstall.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/NPActiveHA.sh;sudo chmod 777 $HOME/NPActiveHA.sh;/bin/bash $HOME/NPActiveHA.sh



#╔══════════╗
#║   Test   ║
#╚══════════╝

journalctl -u nginx.service -b --no-pager
ps axu | grep nginx
nginx -V
sudo cat /var/log/nginx/error.log

sudo curl -k -L --retry 333 -u admin:`cat $HOME/initialPassword` -X GET https://$Master1:443/api/platform/v1/license | jq
sudo curl -k -L --retry 333 -u admin:`cat $HOME/initialPassword` -X GET https://$Master1:443/api/platform/v1/systems | jq



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


