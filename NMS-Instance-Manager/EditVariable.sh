#!/bin/bash -xe

echo "$0"

if [ -z "$2" ]; then
  sudo printf "`date +%Y%m%d%H%M%S` : Environment Variable file argument was not supplied. Using default $HOME/EnvironmentVariable.sh file.\n"
  if [ -f "$HOME/EnvironmentVariable.sh" ]; then
    sudo printf "`date +%Y%m%d%H%M%S` : sourcing $HOME/EnvironmentVariable.sh .\n"
    source $HOME/EnvironmentVariable.sh
  else
    sudo printf "`date +%Y%m%d%H%M%S` : $HOME/EnvironmentVariable.sh file does NOT Exist.\n"
  fi
else
  if [ -f "$2" ]; then
    sudo printf "`date +%Y%m%d%H%M%S` : sourcing $2 .\n"
    source "$2"
  else
    sudo printf "`date +%Y%m%d%H%M%S` : $2 file does NOT Exist.\n"
  fi
fi

if [ -z "$1" ]; then
  sudo printf "`date +%Y%m%d%H%M%S` : Object file argument was not supplied.\n"
else
  if [ -f "$1" ]; then
    sudo printf "`date +%Y%m%d%H%M%S` : editing $1 .\n"

    sudo sed -i 's/$Master1/'"$Master1"'/g' "$1"
    sudo sed -i 's/$Master2/'"$Master2"'/g' "$1"
    sudo sed -i 's/$Master3/'"$Master3"'/g' "$1"
    sudo sed -i 's/$Client1/'"$Client1"'/g' "$1"
    sudo sed -i 's/$Client2/'"$Client2"'/g' "$1"
    sudo sed -i 's/$Client3/'"$Client3"'/g' "$1"
    sudo sed -i 's/$Worker1/'"$Worker1"'/g' "$1"
    sudo sed -i 's/$Worker2/'"$Worker2"'/g' "$1"
    sudo sed -i 's/$Worker3/'"$Worker3"'/g' "$1"
    sudo sed -i 's/$Server1/'"$Server1"'/g' "$1"
    sudo sed -i 's/$Server2/'"$Server2"'/g' "$1"
    sudo sed -i 's/$Server3/'"$Server3"'/g' "$1"
    sudo sed -i 's/$WorkerVIP1/'"$WorkerVIP1"'/g' "$1"
    sudo sed -i 's/$WorkerVIP2/'"$WorkerVIP2"'/g' "$1"
    sudo sed -i 's/$WorkerVIP3/'"$WorkerVIP3"'/g' "$1"

    sudo sed -i 's/$eMaster1/'"$eMaster1"'/g' "$1"
    sudo sed -i 's/$eMaster2/'"$eMaster2"'/g' "$1"
    sudo sed -i 's/$eMaster3/'"$eMaster3"'/g' "$1"
    sudo sed -i 's/$eClient1/'"$eClient1"'/g' "$1"
    sudo sed -i 's/$eClient2/'"$eClient2"'/g' "$1"
    sudo sed -i 's/$eClient3/'"$eClient3"'/g' "$1"
    sudo sed -i 's/$eWorker1/'"$eWorker1"'/g' "$1"
    sudo sed -i 's/$eWorker2/'"$eWorker2"'/g' "$1"
    sudo sed -i 's/$eWorker3/'"$eWorker3"'/g' "$1"
    sudo sed -i 's/$eServer1/'"$eServer1"'/g' "$1"
    sudo sed -i 's/$eServer2/'"$eServer2"'/g' "$1"
    sudo sed -i 's/$eServer3/'"$eServer3"'/g' "$1"
    sudo sed -i 's/$eWorkerVIP1/'"$eWorkerVIP1"'/g' "$1"
    sudo sed -i 's/$eWorkerVIP2/'"$eWorkerVIP2"'/g' "$1"
    sudo sed -i 's/$eWorkerVIP3/'"$eWorkerVIP3"'/g' "$1"

    sudo sed -i 's/$LogPort1/'"$LogPort1"'/g' "$1"
    sudo sed -i 's/$LogPort2/'"$LogPort2"'/g' "$1"
    sudo sed -i 's/$LogPort3/'"$LogPort3"'/g' "$1"
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


