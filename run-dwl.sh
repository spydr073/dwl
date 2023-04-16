#!/usr/bin/env sh

DWL="$HOME/software/dwl/result/bin/dwl"

if [ -z $XDG_RUNTIME_DIR ]; then
    export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$(id -u)
    mkdir -p $XDG_RUNTIME_DIR
fi

#exec ${DWL} > "$HOME/.cache/dwl_info" &

DO=true
while ${DO} || [ -f /tmp/restart_dwl ]; do
    ${DO}=false
    rm -rf /tmp/restart_dwl > /dev/null 2>&1
    ${DWL} > "$HOME/.cache/dwl_info" 
done
