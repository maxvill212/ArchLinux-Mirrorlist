#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

printf "\n"
echo This script locates the 10 fastest https mirrors and outputs them to a new mirrorlist.
echo It will move your current list to mirrorlist_bak and sync your repos with the new list.
printf "\n"

read -p "Enter YES to continue: " input

if [ $input == "YES" ]  
then

    pkg=pacman-contrib
    if ! $(pacman -Qs $pkg > /dev/null)
    then	
	echo "Package pacman-contrib needs to be installed to test speeds"
	pacman -S $pkg
    fi

    mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist_bak

    echo "#  __  __ _                       _      _     _     "  >> /etc/pacman.d/mirrorlist 
    echo "# |  \/  (_)                     | |    (_)   | |    "  >> /etc/pacman.d/mirrorlist 
    echo "# | \  / |_ _ __ _ __ ___  _ __  | |     _ ___| |_   "  >> /etc/pacman.d/mirrorlist
    echo "# | |\/| | | '__| '__/ _ \| '__| | |    | / __| __|  "  >> /etc/pacman.d/mirrorlist
    echo "# | |  | | | |  | | | (_) | |    | |____| \__ \ |_   "  >> /etc/pacman.d/mirrorlist
    echo "# |_|  |_|_|_|  |_|  \___/|_|    |______|_|___/\__|  "  >> /etc/pacman.d/mirrorlist
    echo "# -------------------------------------------------  "  >> /etc/pacman.d/mirrorlist
   
    echo "# Generated: "  $(date) >> /etc/pacman.d/mirrorlist
    echo "" >> /etc/pacman.d/mirrorlist

    curl -s "https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 - >> /etc/pacman.d/mirrorlist
   
    echo mirrorlist generated
    pacman -Syyu
fi
