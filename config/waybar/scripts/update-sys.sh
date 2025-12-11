#!/usr/bin/env bash

# Original script by @speltriao on GitHub
# https://github.com/speltriao/Pacman-Update-for-GNOME-Shell

# If the operating system is not Arch Linux, exit the script successfully
if [ ! -f /etc/arch-release ]; then
    exit 0
fi

# Calculate updates for each service
mapfile -t AURCHECK < <(yay -Qua)
AUR=${#AURCHECK[*]}
mapfile -t OFFICIALCHECK < <( checkupdates )
OFFICIAL=${#OFFICIALCHECK[*]}

AURLIST="AUR\n"

for item in "${AURCHECK[@]}"; do
  AURLIST+=$item"\n"
done

AURLIST+="PACMAN\n"

for item in "${OFFICIALCHECK[@]}"; do
  AURLIST+=$item"\n"
done

# for update in "${AURCHECK[@]}"; do
#   echo $update
#   echo "new--tool"
# done

# If the parameter is "update", update all services
if [ "$1" = "update" ]; then
    kitty --title update-sys sh -c 'yay -Syu'
fi

# If there aren't any parameters, return the total number of updates
if [ "$1" = "" ]; then
    # Calculate total number of updates
    COUNT=$((OFFICIAL+AUR))
    # If there are updates, the script will output the following:   Updates
    # If there are no updates, the script will output nothing.

    if [[ "$COUNT" = "0" ]]
    then
      text=" "
      text+=$COUNT
      echo '{"text":"'"$text"'"}'
    else
      text=" "
      text+=$COUNT
      echo '{"text":"'"$text"'", "class":"update", "tooltip":"'"$AURLIST"'"}'
    fi
    exit 0
fi
