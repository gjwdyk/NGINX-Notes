#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

if [ -z "$1" ] ; then
  WorkerNodeStatus="$HOME/WorkerNodeStatus"
else
  WorkerNodeStatus="$1"
fi
KubernetesVersion="$2"

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
if ( sudo curl -fksSL https://packages.cloud.google.com/apt/doc/apt-key.gpg ) ; then
 sudo curl -fksSL --retry 333 https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
else
 sudo curl -fksSL --retry 333 https://raw.githubusercontent.com/gjwdyk/PublicKeys/main/PackagesCloudGoogleCom_AptDoc_AptKey.gpg | sudo apt-key add -
fi
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo tee /etc/apt/sources.list.d/kubernetes.list << EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

until ((kubeadm version | grep -i "kubeadm" | grep -i "version" | grep -i "info" | grep -i "major" | grep -i "minor") && (kubectl version | grep -i "version" | grep -i "info" | grep -i "major" | grep -i "minor") && (kubelet --version | grep -i "kubernetes")) ; do
 if [ -z "$KubernetesVersion" ] ; then
  let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
  sudo apt-get update -y && sudo apt-get install -y kubelet kubeadm kubectl
 else
  let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
  sudo apt-get update -y && sudo apt-get install -y kubelet=$KubernetesVersion kubeadm=$KubernetesVersion kubectl=$KubernetesVersion
 fi
 # sudo apt-mark hold kubelet kubeadm kubectl
done

if ((kubeadm version | grep -i "kubeadm" | grep -i "version" | grep -i "info" | grep -i "major" | grep -i "minor") && (kubectl version | grep -i "version" | grep -i "info" | grep -i "major" | grep -i "minor") && (kubelet --version | grep -i "kubernetes")) ; then
 echo "`date +%Y%m%d%H%M%S` Worker Node Ready ." | tee $WorkerNodeStatus
else
 echo "`date +%Y%m%d%H%M%S` Error ." | tee $WorkerNodeStatus
fi

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

sudo kubeadm version
sudo kubectl version --client
sudo kubelet --version

#╔═════════════════╗
#║   Information   ║
#╚═════════════════╝

apt-cache policy kubelet | grep -i "installed" -B 1
apt list -a kubelet | grep -i "installed"

apt-cache policy kubeadm | grep -i "installed" -B 1
apt list -a kubeadm | grep -i "installed"

apt-cache policy kubectl | grep -i "installed" -B 1
apt list -a kubectl | grep -i "installed"

#╔═════════╗
#║   End   ║
#╚═════════╝
