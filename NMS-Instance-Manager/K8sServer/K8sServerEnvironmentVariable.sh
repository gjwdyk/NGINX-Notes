#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

export NumberOfWorkerNodes=2
export WorkerNodeNamePrefix='Server'

# Change the value into empty string '' or "", if you just want to install the latest versions but don't know which version is the latest one.
export KubernetesVersion='1.26.3-00'

# Don't change the following variables if you don't really need to and know what you're doing. Below variables can NOT have empty value.
export PodNetworkCIDR='10.244.0.0/16'
export ServiceCIDR='10.96.0.0/12'
export ContainerNetworkInterface='https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/VMPrepContainerNetworkInterface.sh'
export WorkerNodeStatus="$HOME/WorkerNodeStatus"

# Reference:
# https://tldp.org/LDP/abs/html/string-manipulation.html
#
# ${MYVAR#pattern}    # delete shortest match of pattern from the beginning
# ${MYVAR##pattern}   # delete longest match of pattern from the beginning
# ${MYVAR%pattern}    # delete shortest match of pattern from the end
# ${MYVAR%%pattern}   # delete longest match of pattern from the end

# K8sVersion=${KubernetesVersion%-*}
export K8sVersion=${KubernetesVersion%%-*}

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

echo $NumberOfWorkerNodes
echo $WorkerNodeNamePrefix

echo $KubernetesVersion

echo $PodNetworkCIDR
echo $ServiceCIDR
echo $ContainerNetworkInterface
echo $WorkerNodeStatus

echo $K8sVersion

#╔═════════╗
#║   End   ║
#╚═════════╝
