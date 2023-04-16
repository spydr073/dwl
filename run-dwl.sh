#!/usr/bin/env sh

DWL="$HOME/software/dwl/result/bin/dwl"
INFO="$HOME/.cache/dwl_info" 
FLAG="/tmp/restart_dwl"

if [ -z $XDG_RUNTIME_DIR ]; then
    export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$(id -u)
    mkdir -p $XDG_RUNTIME_DIR
fi

#exec ${DWL} > "$HOME/.cache/dwl_info" &

[ -f "${FLAG}" ] || touch "${FLAG}"

while [ -f "${FLAG}" ]; do
    rm -rf "${FLAG}" > /dev/null 2>&1
    swaybg -c "#77dd88" -i "$HOME/dotfiles/wallpapers/oni2.png" -m fit &
    ${DWL} > "${INFO}"
    #swaybg -c "#444444" -i "$HOME/dotfiles/wallpapers/oni2.png" -m fit &
    #swaybg -o \* -i "$HOME/dotfiles/wallpapers/oni2.png" -m fill 
done
