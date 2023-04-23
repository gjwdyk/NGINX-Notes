#!/bin/bash -xe

#╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
#║ Convert Grafana Dashboard Template's Sample PayLoad into New Template which can be used for Automation   ║
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

cd $HOME

if [ -z "$1" ]; then
  sudo printf "`date +%Y%m%d%H%M%S` : Object file argument was not supplied.\n"
else
  if [ -f "$1" ]; then
    cat $1 | jq > $1.json
    rm $1
    sudo sed -i 's/'"`cat WAFLogsUID`"'/$WAFLogsUID/g' $1.json
    sudo sed -i 's/'"`cat WAFDecodedUID`"'/$WAFDecodedUID/g' $1.json
  else
    sudo printf "`date +%Y%m%d%H%M%S` : $1 file does NOT Exist.\n"
  fi
fi



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


