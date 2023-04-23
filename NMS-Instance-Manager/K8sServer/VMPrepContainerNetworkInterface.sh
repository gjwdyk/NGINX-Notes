#!/bin/bash -xe

# ╔════════════╗
# ║   Calico   ║
# ╚════════════╝

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

cd $HOME;sudo curl -fksSL -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/K8sServerEnvironmentVariable.sh;sudo chmod 777 $HOME/K8sServerEnvironmentVariable.sh;sudo chown $(id -u):$(id -g) $HOME/K8sServerEnvironmentVariable.sh;source $HOME/K8sServerEnvironmentVariable.sh

Loop_Period="9s"

CalicoBlockSize=24         # <<<--- Calico Parameter

declare -a file_url
declare -a file_name
declare -a file_acl
declare -a file_own
declare -a file_result

file_url[0]="https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml"         # <<<--- Calico Parameter
file_name[0]="$HOME/calico-operator.yaml"
file_acl[0]="644"
file_own[0]="ubuntu:ubuntu"

file_url[1]="https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml"         # <<<--- Calico Parameter
file_name[1]="$HOME/calico-resources.yaml"
file_acl[1]="644"
file_own[1]="ubuntu:ubuntu"

max_counter=1

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

kubectl create -f $HOME/calico-operator.yaml

cat $HOME/calico-resources.yaml | sed -n '/^ *- blockSize: [0-9]\+$/p'
sed -i 's/- blockSize: [0-9]\+$/- blockSize: '"$CalicoBlockSize"'/g' $HOME/calico-resources.yaml
cat $HOME/calico-resources.yaml | sed -n '/^ *- blockSize: [0-9]\+$/p'

cat $HOME/calico-resources.yaml | sed -n '/^ *cidr: [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+$/p'
sed -i 's#cidr: [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+$#cidr: '"$PodNetworkCIDR"'#g' $HOME/calico-resources.yaml
cat $HOME/calico-resources.yaml | sed -n '/^ *cidr: [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+$/p'

kubectl apply -f $HOME/calico-resources.yaml

Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --namespace calico-system --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --namespace calico-system -o wide --no-headers | grep "Running" | wc -l` -ge `kubectl get pod --namespace calico-system --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` Calico is Ready."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for Calico to be Ready."
  sleep $Loop_Period
 fi
done

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

kubectl get pods --namespace calico-system

#╔═════════╗
#║   End   ║
#╚═════════╝
