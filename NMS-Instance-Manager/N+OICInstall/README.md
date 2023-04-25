# NGINX-Plus Installation with OpenID-Connect

![Under Construction Green](../../Image/UnderConstructionGreen.svg)

<br><br><br>

***

![Under Construction Yellow](../../Image/UnderConstructionYellow.svg)

<br><br><br>

***

![Under Construction Red](../../Image/UnderConstructionRed.svg)

<br><br><br>

***

NGINX OpenID-Connect References:
- [ ] [NGINX OpenID-Connect](https://github.com/nginxinc/nginx-openid-connect)
- [ ] [NGINX OpenID-Connect Lab Example](https://clouddocs.f5.com/training/community/nginx/html/class9/class9.html)



<br><br><br>

***

Below is a snippet code for NGINX-Plus Installation (Not Configured) with OpenID-Connect (Not Configured). The pre-requisite for the installation : the `nginx-repo.crt` and `nginx-repo.key` files must already exist and are located at `$HOME` directory/folder.

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BOICInstall/NPOICInstall.sh;sudo chmod 777 $HOME/NPOICInstall.sh;/bin/bash $HOME/NPOICInstall.sh`



<br><br><br>

***

Below is a snippet code for NGINX-Plus Installation (as LB with [Single Node K8s](../K8sServer#single-node-cluster) as the Application Server) with OpenID-Connect (Not Configured). The pre-requisite for the installation : the `nginx-repo.crt` and `nginx-repo.key` files must already exist and are located at `$HOME` directory/folder.

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BOICInstall/NpLB.sh;sudo chmod 777 $HOME/NpLB.sh;/bin/bash $HOME/NpLB.sh`



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


