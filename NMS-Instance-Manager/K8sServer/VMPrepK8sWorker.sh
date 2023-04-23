#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

if [ -z "$1" ]; then
  NumberOfWorkerNodes=1
else
  NumberOfWorkerNodes="$1"
fi

if [ -z "$2" ]; then
  WorkerNodeNamePrefix='Server'
else
  WorkerNodeNamePrefix="$2"
fi

if [ -z "$3" ]; then
  WorkerNodeStatus="$HOME/WorkerNodeStatus"
else
  WorkerNodeStatus="$3"
fi

Loop_Period="9s"

# Note that the /etc/hosts file must be preconfigured as described below:
# 
# ubuntu@Master1:~$ cat /etc/hosts
# 127.0.0.1       Master1 Master1.Ubuntu localhost
# 192.168.101.11  Master1 Master1.Ubuntu
# 192.168.101.12  Master2 Master2.Ubuntu
# 192.168.101.13  Master3 Master3.Ubuntu
# 192.168.101.21  Client1 Client1.Ubuntu
# 192.168.101.22  Client2 Client2.Ubuntu
# 192.168.101.23  Client3 Client3.Ubuntu
# 192.168.101.101 Worker1 Worker1.Ubuntu
# 192.168.101.102 Worker2 Worker2.Ubuntu
# 192.168.101.103 Worker3 Worker3.Ubuntu
# 192.168.101.201 Server1 Server1.Ubuntu
# 192.168.101.202 Server2 Server2.Ubuntu
# 192.168.101.203 Server3 Server3.Ubuntu
# 192.168.123.11  Master1 Master1.Ubuntu
# 192.168.123.12  Master2 Master2.Ubuntu
# 192.168.123.13  Master3 Master3.Ubuntu
# 192.168.123.21  Client1 Client1.Ubuntu
# 192.168.123.22  Client2 Client2.Ubuntu
# 192.168.123.23  Client3 Client3.Ubuntu
# 192.168.123.101 Worker1 Worker1.Ubuntu
# 192.168.123.102 Worker2 Worker2.Ubuntu
# 192.168.123.103 Worker3 Worker3.Ubuntu
# 192.168.123.201 Server1 Server1.Ubuntu
# 192.168.123.202 Server2 Server2.Ubuntu
# 192.168.123.203 Server3 Server3.Ubuntu
# 
# # The following lines are desirable for IPv6 capable hosts
# ::1     ip6-localhost ip6-loopback
# fe00::0 ip6-localnet
# ff00::0 ip6-mcastprefix
# ff02::1 ip6-allnodes
# ff02::2 ip6-allrouters
# ubuntu@Master1:~$

for counter in $(seq 1 $NumberOfWorkerNodes); do
 Loop="Yes"
 while ( [ "$Loop" == "Yes" ] ) ; do
  if ( ssh -o StrictHostKeyChecking=no $WorkerNodeNamePrefix$counter sudo cat $WorkerNodeStatus | egrep -o "^([0-9]{14} Worker Node Ready \.)$" ) ; then
   echo "`date +%Y%m%d%H%M%S` Worker Node $WorkerNodeNamePrefix$counter is Ready ."
   Loop="No"
  else
   echo "`date +%Y%m%d%H%M%S` Worker Node $WorkerNodeNamePrefix$counter is NOT Ready ."
   sleep $Loop_Period
  fi
 done
 echo "`date +%Y%m%d%H%M%S` Out of Checking Loop for $WorkerNodeNamePrefix$counter ."
 ssh -o StrictHostKeyChecking=no $WorkerNodeNamePrefix$counter sudo `kubeadm token create --print-join-command`

 Loop="Yes"
 while ( [ "$Loop" == "Yes" ] ) ; do
  if [ `kubectl get nodes -o wide --no-headers | grep -i -v 'control-plane' | grep -i '\<Ready' | wc -l` -ge `kubectl get nodes -o wide --no-headers | grep -i -v 'control-plane' | wc -l` ] && [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
   echo "`date +%Y%m%d%H%M%S` All Current Node(s) already joined the Kubernetes Cluster, and All Pods are Completed or Running."
   Loop="No"
  else
   echo "`date +%Y%m%d%H%M%S` Waiting for all Current Node(s) to join the K8s Cluster, and for All Pods to be Completed or Running."
   sleep $Loop_Period
  fi
 done
done

Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get nodes -o wide --no-headers | grep -i -v 'control-plane' | grep -i '\<Ready' | wc -l` -ge $NumberOfWorkerNodes ] ; then
  echo "`date +%Y%m%d%H%M%S` All $NumberOfWorkerNodes Node(s) Already Joined The Kubernetes Cluster."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for $NumberOfWorkerNodes Node(s) to Join the K8s cluster."
  sleep $Loop_Period
 fi
done

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

kubectl get node -o wide
kubectl get pod --all-namespaces -o wide
kubectl get service --all-namespaces -o wide

#╔═════════╗
#║   End   ║
#╚═════════╝
