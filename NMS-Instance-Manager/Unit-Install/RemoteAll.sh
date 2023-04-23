#!/bin/bash -xe

cd $HOME

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Install/RemoteConfigure.sh;sudo chmod 777 $HOME/RemoteConfigure.sh;/bin/bash $HOME/RemoteConfigure.sh
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Sample/DefaultUnitSample.Configuration;sudo curl -X PUT --data-binary @DefaultUnitSample.Configuration http://localhost:43210/config;sudo curl -X GET http://localhost:43210/
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Sample/UnitSampleRemote.sh;sudo chmod 777 $HOME/UnitSampleRemote.sh;/bin/bash $HOME/UnitSampleRemote.sh



#╔══════════╗
#║   Test   ║
#╚══════════╝

journalctl -u unit.service -b --no-pager
ps -ef | grep unit
sudo cat /var/log/unit.log

sudo curl -X GET http://localhost:43210/



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


