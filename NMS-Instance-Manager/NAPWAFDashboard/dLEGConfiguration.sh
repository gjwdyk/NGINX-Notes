#!/bin/bash -xe

#╔══════════════════════════════════════════════════╗
#║ Configure : LogStash - ElasticSearch - Grafana   ║
#╚══════════════════════════════════════════════════╝

cd $HOME/nap-dashboard

#╔═════════════════════════════════════════════════════════════╗
#║   Configure LEG on Docker                                   ║
#║   Reference: https://github.com/skenderidis/nap-dashboard   ║
#║   Modified: https://github.com/gjwdyk/nap-dashboard         ║
#╚═════════════════════════════════════════════════════════════╝

#╔════════════════════════╗
#║   Configure LogStash   ║
#╚════════════════════════╝

# LogStash configuration (i.e. input, filter, output) was inserted during docker container compose/deployment.

#╔═════════════════════════════╗
#║   Configure ElasticSearch   ║
#╚═════════════════════════════╝

Loop_Period="1s"

Loop="Yes"
while ( [ $Loop == "Yes" ] ) ; do
 if ( sudo -u root curl -k -L --retry 333 -X PUT 'http://localhost:9200/signatures/' ) ; then
  echo "`date +%Y%m%d%H%M%S` ElasticSearch is Ready ."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` ElasticSearch is NOT Ready. Wait for $Loop_Period ."
  sleep $Loop_Period
 fi
done

# sudo -u root curl -k -L --retry 333 -X PUT 'http://localhost:9200/signatures/'
sudo -u root curl -k -L --retry 333 -d "@elastic/signature-mapping.json" -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/signatures/_mapping/'
sudo python3 signatures/upload-signatures.py signatures/signatures-report.json localhost
sudo -u root curl -k -L --retry 333 -d "@elastic/template-mapping.json" -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/_template/waf_template?include_type_name'
sudo -u root curl -k -L --retry 333 -d "@elastic/enrich-policy.json" -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/_enrich/policy/signatures-policy'
sudo -u root curl -k -L --retry 333 -X POST 'http://localhost:9200/_enrich/policy/signatures-policy/_execute'
sudo -u root curl -k -L --retry 333 -d "@elastic/sig-lookup.json" -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/_ingest/pipeline/sig_lookup'



#╔═══════════════════════╗
#║   Configure Grafana   ║
#╚═══════════════════════╝

Loop="Yes"
while ( [ $Loop == "Yes" ] ) ; do
 if ( sudo -u root curl -k -L --retry 333 -d "@grafana/DS-waf-index.json" -H 'Content-Type: application/json' -u 'admin:admin' -X POST 'http://localhost:3000/api/datasources/' ) ; then
  echo "`date +%Y%m%d%H%M%S` Grafana is Ready ."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Grafana is NOT Ready. Wait for $Loop_Period ."
  sleep $Loop_Period
 fi
done

# sudo -u root curl -k -L --retry 333 -d "@grafana/DS-waf-index.json" -H 'Content-Type: application/json' -u 'admin:admin' -X POST 'http://localhost:3000/api/datasources/'
sudo -u root curl -k -L --retry 333 -d "@grafana/DS-waf-decoded-index.json" -H 'Content-Type: application/json' -u 'admin:admin' -X POST 'http://localhost:3000/api/datasources/'

#╔═════════════════════════════════════════════════════════════════╗
#║   Additional Grafana Dashboard Configuration                    ║
#║   Reference:                                                    ║
#║   https://grafana.com/docs/grafana/v8.5/http_api/data_source/   ║
#║   https://grafana.com/docs/grafana/v8.5/http_api/dashboard/     ║
#╚═════════════════════════════════════════════════════════════════╝

cd $HOME

sudo -u root curl -H "Accept: application/json" -H "Content-Type: application/json" -u 'admin:admin' http://localhost:3000/api/datasources/name/WAF-Logs | jq | grep uid | tr --delete " \"," | tr -t ":" "\n" | sed -n 2p > $HOME/WAFLogsUID
sudo -u root curl -H "Accept: application/json" -H "Content-Type: application/json" -u 'admin:admin' http://localhost:3000/api/datasources/name/WAF-Decoded | jq | grep uid | tr --delete " \"," | tr -t ":" "\n" | sed -n 2p > $HOME/WAFDecodedUID
echo "WAF-Logs DataSource UID : `cat $HOME/WAFLogsUID`"
echo "WAF-Decoded DataSource UID : `cat $HOME/WAFDecodedUID`"

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NAPWAFDashboard/Grafana-NAP-Main-Dashboard-15675.json;sudo chmod 666 $HOME/Grafana-NAP-Main-Dashboard-15675.json
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NAPWAFDashboard/Grafana-NAP-SupportID-15676.json;sudo chmod 666 $HOME/Grafana-NAP-SupportID-15676.json
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NAPWAFDashboard/Grafana-NAP-Attack-Signatures-15677.json;sudo chmod 666 $HOME/Grafana-NAP-Attack-Signatures-15677.json
cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NAPWAFDashboard/Grafana-NAP-BOT-Dashboard-15678.json;sudo chmod 666 $HOME/Grafana-NAP-BOT-Dashboard-15678.json

sudo sed -i 's/$WAFLogsUID/'"`cat $HOME/WAFLogsUID`"'/g' $HOME/Grafana-NAP-Main-Dashboard-15675.json
sudo sed -i 's/$WAFDecodedUID/'"`cat $HOME/WAFDecodedUID`"'/g' $HOME/Grafana-NAP-Main-Dashboard-15675.json
sudo sed -i 's/$WAFLogsUID/'"`cat $HOME/WAFLogsUID`"'/g' $HOME/Grafana-NAP-SupportID-15676.json
sudo sed -i 's/$WAFDecodedUID/'"`cat $HOME/WAFDecodedUID`"'/g' $HOME/Grafana-NAP-SupportID-15676.json
sudo sed -i 's/$WAFLogsUID/'"`cat $HOME/WAFLogsUID`"'/g' $HOME/Grafana-NAP-Attack-Signatures-15677.json
sudo sed -i 's/$WAFDecodedUID/'"`cat $HOME/WAFDecodedUID`"'/g' $HOME/Grafana-NAP-Attack-Signatures-15677.json
sudo sed -i 's/$WAFLogsUID/'"`cat $HOME/WAFLogsUID`"'/g' $HOME/Grafana-NAP-BOT-Dashboard-15678.json
sudo sed -i 's/$WAFDecodedUID/'"`cat $HOME/WAFDecodedUID`"'/g' $HOME/Grafana-NAP-BOT-Dashboard-15678.json

cd $HOME;sudo curl -H "Accept: application/json" -H "Content-Type: application/json" -u 'admin:admin' -d "@Grafana-NAP-Main-Dashboard-15675.json" -X POST http://localhost:3000/api/dashboards/import
cd $HOME;sudo curl -H "Accept: application/json" -H "Content-Type: application/json" -u 'admin:admin' -d "@Grafana-NAP-SupportID-15676.json" -X POST http://localhost:3000/api/dashboards/import
cd $HOME;sudo curl -H "Accept: application/json" -H "Content-Type: application/json" -u 'admin:admin' -d "@Grafana-NAP-Attack-Signatures-15677.json" -X POST http://localhost:3000/api/dashboards/import
cd $HOME;sudo curl -H "Accept: application/json" -H "Content-Type: application/json" -u 'admin:admin' -d "@Grafana-NAP-BOT-Dashboard-15678.json" -X POST http://localhost:3000/api/dashboards/import



#╔══════════════════════╗
#║   Optional Tool(s)   ║
#╚══════════════════════╝

cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/NAPWAFDashboard/Sample2Template.sh;sudo chmod 777 $HOME/Sample2Template.sh



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


