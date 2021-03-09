#!/usr/bin/env zsh

. ~/.scripts/defs.zsh

# Init Install
initInstall "install_finish"

# Install packages for finishing
if [ $IS_MANJARO = true ]; then
	inst manjaro-wallpapers-18.0
fi
inst libmagick

# powerline in linux console
if [ $IS_GARUDA = true ]; then
    inst terminess-powerline-font-git
    inst terminus-font
    inst powerline-fonts
else
	inst terminus-font
	inst powerline-fonts
fi

###############################
# uninstall unneeded packages #
###############################
fullUninstall

#################################
# install all (needed) packages #
#################################
fullInstall

## FINISHING #
finish

# refresh icons
sudo gdk-pixbuf-query-loaders --update-cache

if [ ! -f "$HOME/.screenlayout/screenlayout.sh" ]; then
	print 'Fehler: keine .screenlayout.sh gefunden'
	exit -1
fi

sudo cp $HOME/.screenlayout/screenlayout.sh /opt
errorCheck "copy screenlayout"

# config lightdm config
sudo cp $SCRIPTS/setup/Xsession /etc/lightdm
sudo chmod +x /etc/lightdm/Xsession
errorCheck "copy Xsession"

if [ -f /etc/lightdm/lightdm.conf ]; then
	sudo mv /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
fi

if [ $IS_MANJARO = true ]; then
	GREETER="lightdm-slick-greeter"
else
	GREETER="lightdm-gtk-greeter"
fi

echo "[Seat:*]
[LightDM]
log-directory=/var/log/lightdm
run-directory=/run/lightdm

[Seat:*]
greeter-session=$GREETER
user-session=xfce
session-wrapper=/etc/lightdm/Xsession
display-setup-script=/opt/screenlayout.sh
[XDMCPServer]
[VNCServer]"  | sudo tee /etc/lightdm/lightdm.conf
errorCheck "lightdm config"

# config slick-greeter
if [ $IS_MANJARO = true ]; then
	GREETER_BACKGROUND="/usr/share/backgrounds/manjaro-wallpapers-18.0/manjaro-cat.jpg"
elif [ $IS_ARCO = true ]; then
	GREETER_BACKGROUND="/usr/share/backgrounds/arcolinux/arco-wallpaper.jpg"
else
	GREETER_BACKGROUND="/usr/share/backgrounds/desert.png"
fi

echo "[Greeter]
background=$GREETER_BACKGROUND
theme-name=Materia-dark
icon-theme-name=Papirus-Dark
activate-numlock=true
cursor-theme-name=Bibata-Modern-Ice
font-name='Cantarell Bold 14'
xft-antialias=true
xft-hintstyle=hintfull
enable-hidpi=auto
draw-user-backgrounds=false
activate-numlock=true
show-power=false
show-a11y=false" | sudo tee /etc/lightdm/slick-greeter.conf
errorCheck "lightdm greeter config"

echo "KEYMAP=de
FONT=ter-powerline-v12n
FONT_MAP=" | sudo tee /etc/vconsole.conf

# grub config
sed 's/.*GRUB_GFXMODE=.*$/GRUB_GFXMODE="1920x1080,auto"/g' </etc/default/grub >grub
sudo mv -f grub /etc/default

if [ $IS_MANJARO = true ]; then
	sudo convert /usr/share/backgrounds/manjaro-wallpapers-18.0/manjaro-cat.jpg /usr/share/grub/themes/manjaro/background.png
	errorCheck "convert manjaro grub image"
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/usr\/share\/grub\/themes\/manjaro\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
	errorCheck "move manjaro grub file"
	sudo cp $SCRIPTS/setup/manjaro-cat.png /usr/share/grub/themes/manjaro/background.png
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/usr\/share\/grub\/themes\/manjaro\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
	echo '#
#
# ==> ADD "bootsplash.bootfile=bootsplash-themes/manjaro/bootsplash" to GRUB_CMDLINE_LINUX_DEFAULT
#' | sudo tee -a /etc/default/grub

	echo '#
#
# ==> ADD "bootsplash-manjaro" to HOOKS
#' | sudo tee -a /etc/mkinitcpio.conf
elif [ $IS_ARCO = true ]; then
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/usr\/share\/grub\/themes\/Vimix\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
	errorCheck "move arco grub file"
elif [ $IS_ARCO != true ]; then
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/boot\/grub\/themes\/Stylish\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
elif [ $IS_GARUDA = true ]; then
	sudo cp $SCRIPTS/setup/manjaro-cat.png /usr/share/grub/themes/garuda/background.png
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/usr\/share\/grub\/themes\/garuda\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
else
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/boot\/grub\/themes\/Stylish\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
fi
errorCheck "grub config"

sudo micro /etc/mkinitcpio.conf
sudo micro /etc/default/grub

sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg

errorCheck "grub mkconfig"

# login screen console
sudo cp $SCRIPTS/issue /etc

# Git config for Visual Studio Code
git config --global diff.tool code
git config --global difftool.code.cmd "$(which code) --wait --diff \"\$LOCAL\" \"\$BASE\" \"\$REMOTE\""
git config --global difftool.prompt false

git config --global merge.tool code
git config --global mergetool.code.cmd "$(which code) --wait \"\$MERGED\""
git config --global mergetool.prompt false

git config --global core.editor micro

git config --global user.name "stira"
git config --global user.email "ralf.stich@infoniqa.com"

sudo git config --system core.editor micro

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=25000'
git config --global push.default simple

git config pull.rebase true   # merge (the default strategy)

git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

# nodejs tools for editors
sudo npm install -g eslint jshint jsxhint stylelint sass-lint markdownlint-cli raml-cop typescript tern js-beautify iconv-lite
errorCheck "install required nodejs-tools"

# Default Browser setzen (vorher $BROWSER Variable entfernen)
export BROWSER=
xdg-settings set default-web-browser google-chrome.desktop

sudo fc-cache -fv
errorCheck "fontcache"

rm -f $PKG_FILE
rm -f $PKG_UNINST_FILE

sudo usermod -aG docker $USER

###########################
# enable services

# printer Service
sudo systemctl enable --now cups
errorCheck "printer service"

# docker
sudo systemctl enable --now docker
errorCheck "docker service"

# webmin
sudo systemctl enable --now webmin
errorCheck "webmin service"

# cockpit
sudo systemctl enable --now cockpit.socket

sudo systemctl enable --now bluetooth-autoconnect
errorCheck "bluetooth-autoconnect service"

sudo systemctl enable --now fstrim.timer
errorCheck "fstrim service"

mkdir -p ~/.config/systemd/user/
sudo cp /usr/lib/systemd/user/pulseaudio-bluetooth-autoconnect.service /etc/systemd/user
systemctl enable pulseaudio-bluetooth-autoconnect --user --now
errorCheck "pulseaudio-bluetooth-autoconnect service"
