# NGINX-Plus Installation with NGINX App Protect WAF

![Under Construction Green](../../Image/UnderConstructionGreen.svg)

<br><br><br>

***

![Under Construction Yellow](../../Image/UnderConstructionYellow.svg)

<br><br><br>

***

![Under Construction Red](../../Image/UnderConstructionRed.svg)

<br><br><br>

***

NAP WAF Configuration References :
- [ ] [NGINX App Protect WAF Configuration Guide](https://docs.nginx.com/nginx-app-protect-waf/configuration-guide/configuration/)
- [ ] [NGINX App Protect WAF Declarative Policy](https://docs.nginx.com/nginx-app-protect-waf/declarative-policy/policy/)



<br><br><br>

***

Sample attacks:

`http://192.168.123.101/apiservice/?a=%3Cscript%3E`

`http://192.168.123.101/apiservice/%09`

`http://192.168.123.101/apiservice/batch.bat`



<br><br><br>

***

Snippet for Installation:

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFInstall/NAPWAFInstall.sh;sudo chmod 777 $HOME/NAPWAFInstall.sh;/bin/bash $HOME/NAPWAFInstall.sh`



<br><br><br>

***

Snippet for Installation and Sample Configuration (as LB Only):

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFInstall/NAPLB.sh;sudo chmod 777 $HOME/NAPLB.sh;/bin/bash $HOME/NAPLB.sh`



<br><br><br>

***

Snippet for Installation and Sample Configuration (as Common Configuration for ALL Services, with Default WAF Configuration):

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFInstall/NAPCommonDefaultWAFLB.sh;sudo chmod 777 $HOME/NAPCommonDefaultWAFLB.sh;/bin/bash $HOME/NAPCommonDefaultWAFLB.sh`



<br><br><br>

***

Snippet for Installation and Sample Configuration (as Per-Service Configuration, each with Default WAF Configuration):

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/N%2BAPWAFInstall/NAPPerServiceDefaultWAFLB.sh;sudo chmod 777 $HOME/NAPPerServiceDefaultWAFLB.sh;/bin/bash $HOME/NAPPerServiceDefaultWAFLB.sh`



<br><br><br>

***

Snippet for LEG Installation and Configuration:

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NAPWAFDashboard/LEGInstall.sh;sudo chmod 777 $HOME/LEGInstall.sh;/bin/bash $HOME/LEGInstall.sh`



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


