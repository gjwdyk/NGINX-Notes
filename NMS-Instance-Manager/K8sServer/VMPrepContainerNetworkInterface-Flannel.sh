#!/bin/bash -xe

# ╔═════════════╗
# ║   Flannel   ║
# ╚═════════════╝

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

cd $HOME;sudo curl -fksSL -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/K8sServerEnvironmentVariable.sh;sudo chmod 777 $HOME/K8sServerEnvironmentVariable.sh;sudo chown $(id -u):$(id -g) $HOME/K8sServerEnvironmentVariable.sh;source $HOME/K8sServerEnvironmentVariable.sh

Loop_Period="9s"

declare -a file_url
declare -a file_name
declare -a file_acl
declare -a file_own
declare -a file_result

file_url[0]="https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml"         # <<<--- Flannel Parameter
file_name[0]="$HOME/kube-flannel.yml"
file_acl[0]="644"
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

cat $HOME/kube-flannel.yml | sed -n '/^ *"Network": "[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+",$/p'
sed -i 's#"Network": "[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+",$#"Network": "'$PodNetworkCIDR'",#g' $HOME/kube-flannel.yml
cat $HOME/kube-flannel.yml | sed -n '/^ *"Network": "[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+",$/p'

kubectl apply -f $HOME/kube-flannel.yml

# Below may not be applicable for aLL cases nor future-proof
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

kubectl get pod --all-namespaces -o wide

#╔═════════╗
#║   End   ║
#╚═════════╝
