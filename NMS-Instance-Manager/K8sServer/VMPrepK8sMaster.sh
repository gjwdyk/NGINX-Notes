#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

if [ -z "$1" ]; then
  PodNetworkCIDR='10.244.0.0/16'
else
  PodNetworkCIDR="$1"
fi

if [ -z "$2" ]; then
  ServiceCIDR='10.96.0.0/12'
else
  ServiceCIDR="$2"
fi

if [ -z "$3" ]; then
  ContainerNetworkInterface='https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/VMPrepContainerNetworkInterface.sh'
else
  ContainerNetworkInterface="$3"
fi

KubernetesVersion="$4"

Loop_Period="9s"

if [ -z "$KubernetesVersion" ] ; then
 let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
 sudo kubeadm init --pod-network-cidr=$PodNetworkCIDR --service-cidr=$ServiceCIDR
else
 let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
 sudo kubeadm init --pod-network-cidr=$PodNetworkCIDR --service-cidr=$ServiceCIDR --kubernetes-version=$KubernetesVersion
fi

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl

declare -a file_url
declare -a file_name
declare -a file_acl
declare -a file_own
declare -a file_result

file_url[0]="$ContainerNetworkInterface"
file_name[0]="$HOME/PrepareContainerNetworkInterface.sh"
file_acl[0]="777"
file_own[0]="ubuntu:ubuntu"

max_counter=0

URLRegEx="^(http:\/\/|https:\/\/)?[a-z0-9]+((\-|\.)[a-z0-9]+)*\.[a-z]{2,}(:[0-9]{1,5})?(\/.*)*$"

for counter in $(seq 0 $max_counter) ; do
 if [[ ${file_url[$counter]} =~ $URLRegEx ]] ; then
  file_result[$counter]=$(/usr/bin/curl -fksSL --retry 333 -w "%{http_code}" ${file_url[$counter]} -o ${file_name[$counter]})
  if [[ ${file_result[$counter]} == 200 ]] ; then
   echo "$counter ; HTTP ${file_result[$counter]} ; ${file_name[$counter]} download complete."
   chown ${file_own[$counter]} ${file_name[$counter]}
   chmod ${file_acl[$counter]} ${file_name[$counter]}
  else
   echo "$counter ; HTTP ${file_result[$counter]} ; Failed to download ${file_name[$counter]} ; Continuing . . ."
  fi
 else
  echo "$counter ; Reference to the ${file_name[$counter]} was not a URL ; Continuing . . ."
 fi
done

/bin/bash $HOME/PrepareContainerNetworkInterface.sh

Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get nodes | grep -i "$(hostname)" | grep -i 'control-plane' | grep -i '\<Ready' | wc -l` -ge 1 ] ; then
  echo "`date +%Y%m%d%H%M%S` Control Plane Node is Ready."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for Control Plane Node to be Ready."
  sleep $Loop_Period
 fi
done

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

kubectl get node -o wide
kubectl get pod --all-namespaces -o wide
kubectl get service --all-namespaces -o wide

#╔═════════╗
#║   End   ║
#╚═════════╝
