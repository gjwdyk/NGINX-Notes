# Application(s) Server(s) within K8s Cluster

## Implement K8s Cluster on VM instances (i.e. VMware workstation).

This section is (my) new version of scripts to implement K8s Cluster on VM instances.

Calico changes a LOT of their implementation, and also the implementation method.
Docker also changes a bit on their implementation method.
Both Calico and Docker unfortunately do NOT support old version of their implementation in a way that you can NOT implement their old versions anymore.
Nor using the old method (i.e. your old script) to implement.
You need to change the scripts to accommodate the new method of implementation.

The experience with Calico and Docker leads to idea of separating the 3rd party implementation in their own piece of script.
Hopefully into the future, these third party can be replaced simply by changing the respective script.
Need to review other CNI which supports K8s' NetworkPolicy as well as VXLan Tunnel (i.e. for integration with F5's CIS) and has good enough performance, to replace Calico.

Originally, Calico is already heavier, for example if you compare to Flannel.
Now, on the new version, Calico gets even more heavier to be implemented and run.

Similarly on the CRI part, there are few modules you can consider to install.
For example `containerd.io` to support the K8s, or you'd like to have feature where you can create/make container modules (i.e. `docker compose` command) with `docker-ce` and `docker-ce-cli`.
Or even having `docker-compose` command with the respective `docker-compose` module.
The more modules you implement the heavier the cluster when it runs.
As well as potential conflicts between the modules (and not to consider additional software also means additional attack surface).

When creating/launching new K8s Cluster with multiple nodes, note that each of the node will try to fetch the implemented software directly from the repository (which in most cases are on the Internet).
Either using `apt` or using K8s when creating pods/containers.
This means creating multinodes cluster creates more loads to the bandwidth.
Or the other way around of saying: creating multinodes cluster is slower, because there are more bytes to be fetched by the cluster.
And because there are more bytes to be fetched, each module will take longer time to reach the "Running" state.
Note that pods have timeout when they're created, so latency is not a good thing when creating pods.

Therefore when you run the scripts in this section, you'll notice a lot of parts of the script are for waiting until the previous module implementation finished first before starting a new one.
This is done to avoid the timeout, congestion and/or conflicts.

Combination of Calico with `containerd.io`, `docker-ce`, `docker-ce-cli` and `docker-compose` on multinodes K8s Cluster manage to consistently clogged up the cluster on my system.
Most of the time, NOT all pods can reach the "Running" state.
And you can NOT delete pods (it will stuck at "Terminating" state forever, and `kubectl` will never return to the prompt).

If you need only K8s Cluster to run the ready-made application you fetch from the Internet, combination of Calico with only `containerd.io` should be ideal; faster and lighter (note that these are relative terms).

Implementation scripts are divided into general tasks group when building K8s Cluster:
- [ ] Configuration of OS ( [`VMPrepOS.sh`](VMPrepOS.sh) )
- [ ] Installation of the CRI ( [`VMPrepContainerRuntimeInterface.sh`](VMPrepContainerRuntimeInterface.sh) )
- [ ] Common installation of K8s, which is identical between control-plane node and worker nodes ( [`VMPrepCommonK8s.sh`](VMPrepCommonK8s.sh) )
- [ ] Configuration/installation of K8s' control-plane node, including installation of CNI ( [`VMPrepK8sMaster.sh`](VMPrepK8sMaster.sh) which calls [`VMPrepContainerNetworkInterface.sh`](VMPrepContainerNetworkInterface.sh) )
  - [ ] In case of building a single node cluster (i.e. one node which takes role both as control-plane node as well as worker node); configuration/installation of single-node cluster, including installation of CNI ( [`VMPrepK8sSingleNode.sh`](VMPrepK8sSingleNode.sh) which calls [`VMPrepContainerNetworkInterface.sh`](VMPrepContainerNetworkInterface.sh) )
- [ ] Configuration for worker nodes to join the K8s Cluster ( [`VMPrepK8sWorker.sh`](VMPrepK8sWorker.sh) )
- [ ] Deploying some Applications on top of the created K8s Cluster ( [`PrepApplicationService.sh`](PrepApplicationService.sh) )

Additional notes on the scripts:
- [ ] [`K8sServerEnvironmentVariable.sh`](K8sServerEnvironmentVariable.sh) helps to consolidate parameters as much as possible. However for 3rd party software such as CRI and CNI, the parameters for those are embedded into their own respective scripts.
- [ ] Within [`K8sServerEnvironmentVariable.sh`](K8sServerEnvironmentVariable.sh), aside of Kubernetes version what you can change are `NumberOfWorkerNodes` and `WorkerNodeNamePrefix` variables. `NumberOfWorkerNodes` is the number of K8s' worker nodes you want. The accepted value must be larger or equal to one. If you wish to create K8s Cluster on a single node (i.e. no specific worker node, or zero worker node), there are separate "wrapper" scripts which do that ( [`VMWrapSingleNodeCluster.sh`](VMWrapSingleNodeCluster.sh) and [`VMWrapSingleNodeClusterApplicationService.sh`](VMWrapSingleNodeClusterApplicationService.sh) ). `WorkerNodeNamePrefix` is the host-name's prefix of the VM which you're aiming to make as the K8s' worker node(s). You might want to refer back to the diagrams on the [main page](../).
- [ ] To simplify the above scripts execution, "wrapper" scripts are created to bundle those according to the target purpose.
  - [ ] [`VMWrapWorker.sh`](VMWrapWorker.sh) creates/prepares K8s worker node(s).
  - [ ] [`VMWrapMaster.sh`](VMWrapMaster.sh) creates K8s control-plane node. The script also make the worker node(s) join the K8s Cluster. When this script finish executing properly, you should have a working but empty K8s Cluster (no applications).
  - [ ] [`VMWrapMasterApplicationService.sh`](VMWrapMasterApplicationService.sh) creates K8s control-plane node. The script also make the worker node(s) join the K8s Cluster. When this script finish executing properly, you should have a working K8s Cluster ***with some Sample Applications***.
  - [ ] [`VMWrapSingleNodeCluster.sh`](VMWrapSingleNodeCluster.sh) creates an empty, single node K8s Cluster.
  - [ ] [`VMWrapSingleNodeClusterApplicationService.sh`](VMWrapSingleNodeClusterApplicationService.sh) creates an empty, single node K8s Cluster ***with some Sample Applications***.
- [ ] There are also some sample alternative scripts, to guide on how to change these scripts. These sample alternative scripts are not actually used or executed. They serve only as working backup. For example, if you want to change the CNI to Flannel, just copy the entire content of [`VMPrepContainerNetworkInterface-Flannel.sh`](VMPrepContainerNetworkInterface-Flannel.sh) and paste-replace into [`VMPrepContainerNetworkInterface.sh`](VMPrepContainerNetworkInterface.sh) . Do this before you execute any of the wrapper script.
  - [ ] [`K8sServerEnvironmentVariable-SampleVersion.sh`](K8sServerEnvironmentVariable-SampleVersion.sh) and [`K8sServerEnvironmentVariable-NoVersion.sh`](K8sServerEnvironmentVariable-NoVersion.sh) describe on how to define which version of Kubernetes to be installed, and which are the worker nodes. Unless you have a specific reason to change the K8s' pod network CIDR and/or the K8s' service CIDR, you should leave the `PodNetworkCIDR` and `ServiceCIDR` variables un-changed to the default values. `ContainerNetworkInterface` refers to bash script which install the CNI into the K8s Cluster. `WorkerNodeStatus` variable refers to file location where worker node(s) can let control-plane node knows that it has finished the preparation and can receive instruction to join the K8s Cluster.
  - [ ] [`VMPrepContainerNetworkInterface-Calico.sh`](VMPrepContainerNetworkInterface-Calico.sh) and [`VMPrepContainerNetworkInterface-Flannel.sh`](VMPrepContainerNetworkInterface-Flannel.sh) are the available two alternative CNI scripts, which you can use either one.
  - [ ] [`VMPrepContainerRuntimeInterface-ContainerD.sh`](VMPrepContainerRuntimeInterface-ContainerD.sh) install and configure `containerd.io` as the CRI for K8s Cluster.
  - [ ] [`VMPrepContainerRuntimeInterface-DockerCEContainerD.sh`](VMPrepContainerRuntimeInterface-DockerCEContainerD.sh) install `containerd.io`, `docker-ce` and `docker-ce-cli`. Configuration wise this script may need some tuning, but up to time of this document written this script works just fine.
  - [ ] [`VMPrepContainerRuntimeInterface-DockerCEComposeContainerD.sh`](VMPrepContainerRuntimeInterface-DockerCEComposeContainerD.sh) install `containerd.io`, `docker-ce`, `docker-ce-cli` and `docker-compose`. As described earlier, this script may NOT work well.
- [ ] Additional other files.
  - [ ] [`id_rsa`](id_rsa) and [`id_rsa.pub`](id_rsa.pub) are SSH private and public keys, needed so that the control-plane node can send instructions to the worker node to join the K8s Cluster. Note that the SSH keys can be used to gain access to your machines or instances. Therefore it is ***absolutely recommended*** that you use SSH keys which you [create by yourself](https://manpages.ubuntu.com/manpages/focal/en/man1/ssh-keygen.1.html). And/or ensure that your machines/instances are NOT reachable by any un-trusted party/entity.
  - [ ] [`JigokuShoujo43x25.text`](JigokuShoujo43x25.text) signature file to mark the end of the scripts execution. Due to the considerable time taken to deploy the scripts to create K8s Cluster, most of the time you can leave the system work on its own until finish. The signature makes it easy to spot the finish from far away, without having to approach your console to read/review the status of the scripts execution. Just some conveniences.
  - [ ] [`README.md`](README.md) is this file you're reading now.



<br><br><br>

***

## Worker Node

Execute the following command snippet on each of the Worker node:

`cd $HOME;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/VMWrapWorker.sh;sudo chmod 777 $HOME/VMWrapWorker.sh;sudo chown $(id -u):$(id -g) $HOME/VMWrapWorker.sh;/bin/bash $HOME/VMWrapWorker.sh`



<br><br><br>

***

## Control Plane node

Execute the following command snippet on the Control Plane node:

`cd $HOME;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/VMWrapMaster.sh;sudo chmod 777 $HOME/VMWrapMaster.sh;sudo chown $(id -u):$(id -g) $HOME/VMWrapMaster.sh;/bin/bash $HOME/VMWrapMaster.sh`



<br><br><br>

***

Execute the following command snippet on the Control Plane node, if you'd like the created K8s Cluster to be populated with some sample Application Services:

`cd $HOME;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/VMWrapMasterApplicationService.sh;sudo chmod 777 $HOME/VMWrapMasterApplicationService.sh;sudo chown $(id -u):$(id -g) $HOME/VMWrapMasterApplicationService.sh;/bin/bash $HOME/VMWrapMasterApplicationService.sh`



<br><br><br>

***

## Single Node Cluster

Execute the following command snippet, if you'd like to build a Single Node K8s Cluster:

`cd $HOME;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/VMWrapSingleNodeCluster.sh;sudo chmod 777 $HOME/VMWrapSingleNodeCluster.sh;sudo chown $(id -u):$(id -g) $HOME/VMWrapSingleNodeCluster.sh;/bin/bash $HOME/VMWrapSingleNodeCluster.sh`



<br><br><br>

***

Execute the following command snippet, if you'd like to build a Single Node K8s Cluster, with some sample Application Services:

`cd $HOME;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/VMWrapSingleNodeClusterApplicationService.sh;sudo chmod 777 $HOME/VMWrapSingleNodeClusterApplicationService.sh;sudo chown $(id -u):$(id -g) $HOME/VMWrapSingleNodeClusterApplicationService.sh;/bin/bash $HOME/VMWrapSingleNodeClusterApplicationService.sh`



<br><br><br>

***

## Applications Only

Execute the following command snippet, to deploy Sample Applications on top of Existing K8s Cluster:

`cd $HOME;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/K8sServer/PrepApplicationService.sh;sudo chmod 777 $HOME/PrepApplicationService.sh;sudo chown $(id -u):$(id -g) $HOME/PrepApplicationService.sh;/bin/bash $HOME/PrepApplicationService.sh`



<br><br><br>

***

## Building the node(s) from scratch

The below is optional, in case you'd like to build the node(s) from scratch (i.e from the Ubuntu Server 20.04 `.iso` file).
Kindly refer back to diagrams on [main page](../), to help you understand why the configuration sample are as below.
The steps below need to be performed on each node(s).

During the installation from Ubuntu Server 20.04 `.iso` file, create a user called `ubuntu`.
After you have finished with the installation from Ubuntu Server 20.04 `.iso` file, run the command `sudo visudo`, and add following lines:

`root    ALL=(ALL:ALL) NOPASSWD:ALL`

`ubuntu  ALL=(ALL:ALL) NOPASSWD:ALL`

Note that the above two lines need to be added AT THE END OF THE FILE.
Default editor is `vi` (so refer to [`vi` manual](https://manpages.ubuntu.com/manpages/focal/man1/vi.1posix.html) or [Introduction to the vi editor](https://www.redhat.com/sysadmin/introduction-vi-editor) for editing).
You can change the default editor to `nano`, but that's outside of this repository's scope.
Below is the sample result of `/etc/sudoers`:

```
ubuntu@Master1:~$ sudo cat /etc/sudoers
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d

root     ALL=(ALL:ALL) NOPASSWD:ALL
ubuntu   ALL=(ALL:ALL) NOPASSWD:ALL

ubuntu@Master1:~$
```

Configure/change the node's name properly, if you haven't done so during the installation of Ubuntu Server 20.04 from the offical `.iso` file:

`sudo hostnamectl set-hostname Master1.Ubuntu`

Refer to the `/etc/hosts` file below for the name(s) of the node(s).

Configure/change the Networking/Interface information properly, if you haven't done so during the installation of Ubuntu Server 20.04 from the offical `.iso` file.
Below is an example `/etc/netplan/00-installer-config.yaml` network configuration file.
You may want to refer back to diagrams on [main page](../), to help you understand the network configuration file.

```
ubuntu@Master1:~$ cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.101.11/24
      gateway4: 192.168.101.8
      nameservers:
        addresses:
        - 192.168.101.8
        search:
        - ubuntu
    ens34:
      addresses:
      - 192.168.123.11/24
      nameservers:
        addresses: []
        search:
        - ubuntu
  version: 2
ubuntu@Master1:~$
```

You need to `reboot` the unit/instance after editing the `/etc/netplan/00-installer-config.yaml` file, to make the new network configuration takes effect.

Finally, configure the `/etc/hosts` file so each of the node can address the other with their name instead of their IP Address(es).
Below is an example `/etc/hosts`:

```
ubuntu@Master1:~$ cat /etc/hosts
127.0.0.1       Master1 Master1.Ubuntu localhost         # This line will differ from one node to the other
192.168.101.11  Master1 Master1.Ubuntu
192.168.101.12  Master2 Master2.Ubuntu
192.168.101.13  Master3 Master3.Ubuntu
192.168.101.21  Client1 Client1.Ubuntu
192.168.101.22  Client2 Client2.Ubuntu
192.168.101.23  Client3 Client3.Ubuntu
192.168.101.101 Worker1 Worker1.Ubuntu
192.168.101.102 Worker2 Worker2.Ubuntu
192.168.101.103 Worker3 Worker3.Ubuntu
192.168.101.201 Server1 Server1.Ubuntu
192.168.101.202 Server2 Server2.Ubuntu
192.168.101.203 Server3 Server3.Ubuntu
192.168.123.11  Master1 Master1.Ubuntu
192.168.123.12  Master2 Master2.Ubuntu
192.168.123.13  Master3 Master3.Ubuntu
192.168.123.21  Client1 Client1.Ubuntu
192.168.123.22  Client2 Client2.Ubuntu
192.168.123.23  Client3 Client3.Ubuntu
192.168.123.101 Worker1 Worker1.Ubuntu
192.168.123.102 Worker2 Worker2.Ubuntu
192.168.123.103 Worker3 Worker3.Ubuntu
192.168.123.201 Server1 Server1.Ubuntu
192.168.123.202 Server2 Server2.Ubuntu
192.168.123.203 Server3 Server3.Ubuntu

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ubuntu@Master1:~$
```

After you do the above steps to all nodes, you can start executing the "wrapper" script(s), as explained above.



<br><br><br>

***

<br><br><br>
```
╔═╦═════════════════╦═╗
╠═╬═════════════════╬═╣
║ ║ End of Document ║ ║
╠═╬═════════════════╬═╣
╚═╩═════════════════╩═╝
```
<br><br><br>


