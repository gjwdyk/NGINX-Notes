#!/bin/bash -xe

#╔════════════════════════════════════════════════════════════╗
#║ Pre-Requisites :                                           ║
#║ nginx-repo.crt, nginx-repo.key and nginx-manager.lic files ║
#║ exist and are located at $HOME directory/folder.           ║
#╚════════════════════════════════════════════════════════════╝

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BInstall/NPInstall.sh;sudo chmod 777 $HOME/NPInstall.sh;/bin/bash $HOME/NPInstall.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NIM2-Manager/ClickHouseInstall.sh;sudo chmod 777 $HOME/ClickHouseInstall.sh;/bin/bash $HOME/ClickHouseInstall.sh

# sudo mkdir -p /etc/ssl/nginx
# sudo cp nginx-*.crt /etc/ssl/nginx/nginx-repo.crt
# sudo cp nginx-*.key /etc/ssl/nginx/nginx-repo.key
sudo mv nginx-*.lic $HOME/nginx-manager.lic
ls -lap /etc/ssl/nginx/
ls -lap $HOME/nginx-manager.lic

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get install -y apt-transport-https lsb-release ca-certificates jq
sudo wget --retry-connrefused --retry-on-host-error --tries=333 https://nginx.org/keys/nginx_signing.key
#sudo wget --retry-connrefused --retry-on-host-error --tries=333 https://cs.nginx.com/static/keys/nginx_signing.key   # different version of the command
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-key add nginx_signing.key

printf "deb https://pkgs.nginx.com/nms/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
sudo wget --retry-connrefused --retry-on-host-error --tries=333 -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get update -y
sudo cat /etc/apt/apt.conf.d/90pkgs-nginx

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
#sudo apt-get install -y nms-instance-manager=2.4.0-614112268~focal | sudo tee $HOME/nms-instance-manager-output
sudo apt-get install -y nms-instance-manager | sudo tee $HOME/nms-instance-manager-output

base64 $HOME/nginx-manager.lic | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' | tee $HOME/nginx-manager-base64.lic
cat nms-instance-manager-output | grep "Admin username: " -A 2 | grep "Admin password: " | grep -e "[a-zA-Z0-9]*" -o | sed -n 3p | sudo tee $HOME/initialPassword
cat $HOME/nginx-manager-base64.lic
cat $HOME/initialPassword

sudo systemctl restart clickhouse-server
sudo systemctl enable clickhouse-server
sudo systemctl restart nginx
sudo systemctl enable nginx
sudo systemctl restart nms
sudo systemctl enable nms
sudo systemctl enable nms-core
sudo systemctl enable nms-dpm
sudo systemctl enable nms-ingestion
sudo systemctl enable nms-integrations

sudo curl -k -L --retry 333 -u admin:`cat $HOME/initialPassword` -X PUT -H 'accept: application/json' -H 'Content-Type: application/json' --data "{ \"desiredState\": { \"content\": \"`cat $HOME/nginx-manager-base64.lic`\" }, \"metadata\": { \"name\": \"license\" } }" https://127.0.0.1:443/api/platform/v1/license | jq



#╔═══════════════════════════════════════════════════════╗
#║   Respond Configuration Information to NGINX+ Nodes   ║
#╚═══════════════════════════════════════════════════════╝

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NIM2-N%2BHA/tServer.sh;sudo chmod 777 $HOME/tServer.sh
echo "Waiting for other nodes to sync-up."
let counter=0;while true;do let counter++;/bin/bash $HOME/tServer.sh;echo "$counter";if (([ -f $HOME/tStop ]) && (cat $HOME/tStop | grep -E "^[a-zA-Z0-9]{30}$"));then break;fi;done



#╔══════════╗
#║   Test   ║
#╚══════════╝

ps aufx | grep nms

journalctl -u clickhouse-server.service -b --no-pager
journalctl -u nginx.service -b --no-pager
journalctl -u nms.service -b --no-pager
journalctl -u nms-core.service -b --no-pager
journalctl -u nms-dpm.service -b --no-pager
journalctl -u nms-ingestion.service -b --no-pager
journalctl -u nms-integrations.service -b --no-pager

sudo nms-core -v

# sudo cat /var/log/clickhouse-server/clickhouse-server.log
sudo cat /var/log/clickhouse-server/clickhouse-server.err.log
sudo cat /var/log/nginx/error.log
sudo cat /var/log/nms/nms.log

printf "\e[1;33mNMS Instance Manager version 2 - UserName:\e[0m \e[1;31madmin\e[0m \e[1;33mPassword:\e[0m \e[1;31m`cat $HOME/initialPassword`\e[0m\n"



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


