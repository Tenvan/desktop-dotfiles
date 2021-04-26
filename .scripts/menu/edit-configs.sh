#!/usr/bin/env bash

# Function create a scale dialog
filesEdit="code -a --file-uri"
folderEdit="code -a --folder-uri"
# filesEdit="atom "
# folderEdit="atom "

ACTIONS=(
    "🇬 Editor" "code"
    "🇬 Workspace" "code -r $HOME/dotfiles.code-workspace"
    "📁 config dir" "$folderEdit $HOME/.config"
    "📁 awesome dir" "$folderEdit $HOME/.config/awesome"
    "📁 ulauncher dir" "$folderEdit $HOME/.config/ulauncher"
    "📁 themix templates" "$folderEdit $HOME/.config/oomox/base16/templates"
    "📁 terminal configs" "$filesEdit $HOME/.config/alacritty/* $HOME/.config/kitty/* $HOME/.Xresources*"
    "📑 shell configs" "$filesEdit $HOME/.profile* $HOME/.x* $HOME/.X* $HOME/.zsh* $HOME/.*.zsh $HOME/.alias* $HOME/.bashrc*"
    "📑 scripts autostart" "$filesEdit $SCRIPTS/autostart*.sh"
    "📑 scripts install" "$filesEdit $SCRIPTS/install*"
    "📁 scripts dir" "$folderEdit $SCRIPTS"
    "📁 menu dir" "$folderEdit $SCRIPTS/menu"
    "📑 ranger" "$filesEdit $HOME/.config/ranger/*.sh $HOME/.config/ranger/*.conf"
    "📁 picom dir" "$folderEdit  $HOME/.config/picom"
    "📁 neofetch" "$folderEdit $HOME/.config/neofetch"
    "📑 themes Files" "$filesEdit $HOME/.Xresources* $HOME/.gtkrc-*"
    "📁 themes FolderQT5" "$folderEdit  $HOME/.config/gtk-3.0 $HOME/.config/gtk-4.0 $HOME/.config/qt5ct $HOME/.config/fontconfig"
    "📑 screenlayout" "$filesEdit $HOME/.screenlayout/*"
    "📑 gitignore" "$filesEdit $HOME/.gitignore"
)

LINECOUNT=$(expr ${#ACTIONS[*]} / 2)
LINEHEIGHT=$(($LINECOUNT * $LINEHEIGHT))
OFFSET=120
HEIGHT=$(($LINEHEIGHT + $OFFSET))

get_config_list() {
    zenity --list \
        --width=400 \
        --height=$HEIGHT \
        --title="Edit Konfiguation" \
        --text="Konfig file" \
        --column="Option" \
        --column="Datei" \
        --separator=" " \
        --print-column=2 \
        --hide-column=2 \
        --hide-header \
        "${ACTIONS[@]}"
}

choice=$(get_config_list)

if [ -z "$choice" ]; then
    echo "abort choice"
else
    echo $choice
    $choice &
fi
