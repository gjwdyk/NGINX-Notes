#!/bin/bash -xe

#╔══════════════════════════════════════════════════════════════╗
#║ Install and Configure : LogStash - ElasticSearch - Grafana   ║
#╚══════════════════════════════════════════════════════════════╝

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/EnvironmentVariable.sh;sudo chmod 777 $HOME/EnvironmentVariable.sh;source $HOME/EnvironmentVariable.sh
cd $HOME/nap-dashboard

#╔═════════════════════════════════════════════════════════════╗
#║   Install LEG on Docker                                     ║
#║   Reference: https://github.com/skenderidis/nap-dashboard   ║
#║   Modified: https://github.com/gjwdyk/nap-dashboard         ║
#╚═════════════════════════════════════════════════════════════╝

# Change LogStash listening port to > 1024.
sudo sed -i "s/- 515:515/- $LogPort1:$LogPort1/g" docker-compose.yaml
sudo sed -i "s/port => 515/port => $LogPort1/g" logstash.conf

TZ=Asia/Jakarta && sudo docker-compose up -d

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NAPWAFDashboard/dLEGConfiguration.sh;sudo chmod 777 $HOME/dLEGConfiguration.sh;/bin/bash $HOME/dLEGConfiguration.sh



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


