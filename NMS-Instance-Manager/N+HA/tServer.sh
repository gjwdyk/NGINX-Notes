#!/bin/bash -xe

coproc nc -l 0.0.0.0 43210

while read -r cmd; do
  case $cmd in
    q) break ;;
    *) cat $HOME/configurationState
  esac
done <&"${COPROC[0]}" >&"${COPROC[1]}"

kill "$COPROC_PID"



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


