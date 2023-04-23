# NGINX OpenSource Installation

You can review reference installation for NGINX Open Source, for many flavor of Linux at [NGINX Linux Packages](https://nginx.org/en/linux_packages.html).

Or you can use below [NOSInstall.sh](NOSInstall.sh) script to install NGINX OpenSource version.

Preparation to update `apt` modules helps you to be able to obtain a more updated version of NGINX.

```
sudo wget --retry-connrefused --retry-on-host-error --tries=333 https://nginx.org/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
sudo apt-get install -y apt-transport-https lsb-release ca-certificates
printf "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx\n" | sudo tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx
```

You can directly do update and install NGINX (i.e. without the above preparation), which might give you the NGINX version from ubuntu server, instead of from NGINX server.

```
sudo apt-get update -y
sudo apt-get install -y nginx
```

Find out the available versions from `apt-cache madison` command.

```
ubuntu@K8sNode1:~$ apt-cache madison nginx
     nginx | 1.20.2-1~focal | http://nginx.org/packages/ubuntu focal/nginx amd64 Packages
     nginx | 1.20.1-1~focal | http://nginx.org/packages/ubuntu focal/nginx amd64 Packages
     nginx | 1.20.0-1~focal | http://nginx.org/packages/ubuntu focal/nginx amd64 Packages
     nginx | 1.18.0-2~focal | http://nginx.org/packages/ubuntu focal/nginx amd64 Packages
     nginx | 1.18.0-1~focal | http://nginx.org/packages/ubuntu focal/nginx amd64 Packages
     nginx | 1.18.0-0ubuntu1.2 | http://id.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages
     nginx | 1.18.0-0ubuntu1.2 | http://id.archive.ubuntu.com/ubuntu focal-security/main amd64 Packages
     nginx | 1.17.10-0ubuntu1 | http://id.archive.ubuntu.com/ubuntu focal/main amd64 Packages
ubuntu@K8sNode1:~$
```

Once you found the version you need to install, define it at the `apt-get install` command.

```
sudo apt-get install -y nginx=1.20.2-1~focal
```



<br><br><br>

You can copy paste below commands to download and execute the [NOSInstall.sh](NOSInstall.sh) script on your local Ubuntu 20.04 machine.

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NOS-Install/NOSInstall.sh;sudo chmod 777 $HOME/NOSInstall.sh;/bin/bash $HOME/NOSInstall.sh`



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


