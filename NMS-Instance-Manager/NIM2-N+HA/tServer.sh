#!/bin/bash -xe

#╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
#║ Note :                                                                                                           ║
#║ Do NOT call the "b" right after the "q" in succession; it may cause the "q" return empty string.                 ║
#║ Insert a lengthy process in between, to provide enough time for the "q" return value to be stored by the caller. ║
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

coproc nc -l 0.0.0.0 12345

while read -r cmd; do
  case $cmd in
    q) cat $HOME/initialPassword ; break ;;
    b) cat $HOME/initialPassword | sudo tee $HOME/tStop ; break ;;
    *) break ;;
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


