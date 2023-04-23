#!/bin/bash -xe

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Install/LocalConfigure.sh;sudo chmod 777 $HOME/LocalConfigure.sh;/bin/bash $HOME/LocalConfigure.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Sample/DefaultUnitSample.Configuration;sudo curl -X PUT --data-binary @DefaultUnitSample.Configuration --unix-socket /var/run/control.unit.sock http://localhost/config;sudo curl -X GET --unix-socket /var/run/control.unit.sock http://localhost/
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Sample/UnitSampleLocal.sh;sudo chmod 777 $HOME/UnitSampleLocal.sh;/bin/bash $HOME/UnitSampleLocal.sh



#╔══════════╗
#║   Test   ║
#╚══════════╝

journalctl -u unit.service -b --no-pager
ps -ef | grep unit
sudo cat /var/log/unit.log

sudo curl -X GET --unix-socket /var/run/control.unit.sock http://localhost/



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


