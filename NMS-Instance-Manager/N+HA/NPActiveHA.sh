#!/bin/bash -xe

LoopWaitPeriod="22s"

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EditVariable.sh;sudo chmod 777 $HOME/EditVariable.sh

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get install -y nginx-ha-keepalived
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/ActiveKeepAlived.conf;sudo chmod 666 $HOME/ActiveKeepAlived.conf;/bin/bash $HOME/EditVariable.sh $HOME/ActiveKeepAlived.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/ActiveKeepAlived.conf /etc/keepalived/keepalived.conf;sudo systemctl restart keepalived
sudo systemctl enable keepalived

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get install -y nginx-sync
sudo ls -lap /root/.ssh/
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/BADPrivateKey;sudo chmod 666 $HOME/BADPrivateKey;sudo printf "`cat $HOME/BADPrivateKey`\n" | sudo tee -a /root/.ssh/id_rsa
sudo ls -lap /root/.ssh/
sudo chown root:root /root/.ssh/id_rsa
sudo chmod 600 /root/.ssh/id_rsa
sudo ls -lap /root/.ssh/
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/BADPublicKey;sudo chmod 666 $HOME/BADPublicKey;sudo printf "`cat $HOME/BADPublicKey`\n" | sudo tee -a /root/.ssh/id_rsa.pub
sudo ls -lap /root/.ssh/
sudo chown root:root /root/.ssh/id_rsa.pub
sudo chmod 600 /root/.ssh/id_rsa.pub
sudo ls -lap /root/.ssh/

while ( ! ( printf "\nq\n" | nc $Worker2 43210 | grep "Finish Configuration" ) ); do
 echo "`date +%Y%m%d%H%M%S` Wait for StandBy Node to Finish Configuration . Sleep for $LoopWaitPeriod ."
 sleep $LoopWaitPeriod
done

sudo ssh -o StrictHostKeyChecking=no root@$Worker2 exit
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BHA/nginx-sync.conf;sudo chmod 666 $HOME/nginx-sync.conf;/bin/bash $HOME/EditVariable.sh $HOME/nginx-sync.conf $HOME/EnvironmentVariable.sh;sudo mv $HOME/nginx-sync.conf /etc/nginx-sync.conf
sudo nginx-sync.sh -C -d
sudo nginx-sync.sh



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

sudo nginx-sync.sh -C -d



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


