#!/bin/bash -xe

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EditVariable.sh;sudo chmod 777 $HOME/EditVariable.sh

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get install -y nginx-ha-keepalived
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/StandByKeepAlived.conf;sudo chmod 666 $HOME/StandByKeepAlived.conf;/bin/bash $HOME/EditVariable.sh $HOME/StandByKeepAlived.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/StandByKeepAlived.conf /etc/keepalived/keepalived.conf;sudo systemctl restart keepalived
sudo systemctl enable keepalived

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get install -y nginx-sync
sudo ls -lap /root/.ssh/
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/BADPublicKey;sudo chmod 666 $HOME/BADPublicKey;sudo printf "`cat $HOME/BADPublicKey`\n" | sudo tee -a /root/.ssh/authorized_keys
sudo ls -lap /root/.ssh/
sudo chown root:root /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys
sudo ls -lap /root/.ssh/
sudo sed s/#PermitRootLogin\ prohibit-password/PermitRootLogin\ without-password/g /etc/ssh/sshd_config > $HOME/sshd_config
sudo chown root:root $HOME/sshd_config
sudo chmod 644 $HOME/sshd_config
sudo mv $HOME/sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "Finish Configuration" > $HOME/configurationState



#╔══════════╗
#║   Test   ║
#╚══════════╝

sudo cat /etc/keepalived/keepalived.conf
sudo cat /var/run/nginx-ha-keepalived.state
sudo service keepalived dump
sudo cat /tmp/keepalived.data
sudo cat /tmp/keepalived.stats
sudo ip address
sudo cat /var/log/syslog | grep "keepalive"

sudo cat /etc/nginx/nginx.conf
sudo cat /etc/nginx/conf.d/default.conf



#╔════════════════════════════════════════════════╗
#║   Respond Configuration State to Active Node   ║
#╚════════════════════════════════════════════════╝

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/tServer.sh;sudo chmod 777 $HOME/tServer.sh;echo "Waiting for other nodes to sync-up.";/bin/bash $HOME/tServer.sh



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


