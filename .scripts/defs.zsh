#!/usr/bin/env zsh

#####################
# init distro check #
#####################
LINUX_VERSION_NAME=$(lsb_release -si)
IS_ARCH=false
IS_ARCO=false
IS_MANJARO=false
IS_GARUDA=false
IS_ENDEA=false

SCRIPTS="$HOME/.scripts"

PACKER=yay
DEBUG=false

#DEBUG=true
ERROR_PAKAGE_UNINST=
ERROR_PAKAGE_INST=

if [ $LINUX_VERSION_NAME = "ArchLinux" ]; then
	IS_ARCH=true
fi

if [ $LINUX_VERSION_NAME = "ArcoLinux" ]; then
	IS_ARCO=true
fi

if [ $LINUX_VERSION_NAME = "ManjaroLinux" ]; then
	IS_MANJARO=true
fi

if [ $LINUX_VERSION_NAME = "Garuda" ]; then
	IS_GARUDA=true
fi

if [ $LINUX_VERSION_NAME = "EndeavourOS" ]; then
	IS_ENDEA=true
fi

echo "Linux Version: $LINUX_VERSION_NAME"
echo "IsArch:        $IS_ARCH"
echo "IsArco:        $IS_ARCO"
echo "IsGaruda:      $IS_GARUDA"
echo "IsManjaro:     $IS_MANJARO"
echo "IsEndeavourOS: $IS_ENDEA"

MAKEFLAGS="-j$(nproc)"
PAKKER_ALL="--color always --needed --noconfirm"

initInstall() {
	INSTALL_SCRIPT=$1
	echo "Step: init Install '$INSTALL_SCRIPT'"
	sudo rm /var/lib/pacman/db.lck 2&> /dev/null	
}

inst() {
    PAKAGE_INST="${PAKAGE_INST} $1"
    
    if [ $DEBUG = true ]; then
		eval "$PACKER -S $PAKKER_ALL $1"
		
	    retVal=$?
	    if [ $retVal -ne 0 ]; then
	        echo "error on install: $1"
			ERROR_PAKAGE_INST="${ERROR_PAKAGE_INST} $1"        
	    fi
    fi
}

fullInstall() {
	echo "Step: full Install"
	if [ $DEBUG != true -a "$PAKAGE_INST" != "" ]; then
		eval "$PACKER -S $PAKKER_ALL $PAKAGE_INST"
		# errorCheck "install packages"
	fi
}

uninst() {
    PAKAGE_UNINST="${PAKAGE_UNINST} $1"

    eval "$PACKER -R $1"
    
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "error on uninstall: $1"
		ERROR_PAKAGE_UNINST="${ERROR_PAKAGE_UNINST} $1"        
    fi
}

fullUninstall() {
	printf "Step: full Uninstall"
	if [ $DEBUG != true -a "$PAKAGE_UNINST" != "" ]; then
		eval "$PACKER -R --noconfirm $PAKAGE_UNINST"
	fi
}

errorCheck() {
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "abort installation script '$INSTALL_SCRIPT': $1 ($retVal)"
        exit $retVal
    fi
}

finish() {
	echo "Step: finish Install"

	if [ "$ERROR_PAKAGE_UNINST" = "" ]; then
		echo 'No Errors on Uninstall'
	else
		echo "Error on Uninstall: ${ERROR_PAKAGE_UNINST}"
	fi	

	if [ "$ERROR_PAKAGE_INST" = "" ]; then
		echo 'No Errors on Install'
	else
		echo "Error on Install: ${ERROR_PAKAGE_INST}"
	fi	
}

run() {
    if command -v $1 &>/dev/null; then
        #pgrep -u "$USER" -fx "$1" >/dev/null || ($@) &
        if ! pgrep "$1"; then
            $@ &
        fi
    else
        notify-send -t 10000 -u critical "Error Start" "Kommando '$1' nicht gefunden"
    fi
}

restart() {
    killall "$1"
    sleep 1
    run $@
}

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *.deb) ar x $1 ;;
    *.tar.xz) tar xf $1 ;;
    *.tar.zst) unzstd $1 ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
