#/bin/bash!
orange=`tput setaf 11`
bg_orange=`tput setab 178`
purple=`tput setaf 13`
Line=`tput smul`
bold=`tput bold`
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 15`
reset=`tput sgr0`
bg_red=`tput setab 1`
bg_green=`tput setab 2`
bg_white=`tput setab 7`
bg_blue=`tput setab 4`
lightblue=`tput setaf 45`
lightgreen=`tput setaf 46`
bleuetern=`tput setaf 45`
ilghtpurple=`tput setaf 33`
lightred=`tput setaf 161`
darkblue=`tput setaf 19`
dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd $dir

find diskinfo/SongInfo/ -name *_Song_info.txt | sed 's/\/\//\//g' > tmp/temp_tracks_menu
IFS=$'\n'       # Processing line
set -f          # disable globbing

if [ -f tmp/track_menu_select ]
then
rm tmp/track_menu_select
fi
for tracks_titles in $(cat tmp/temp_tracks_menu)
do
trackpose=$(cat "$tracks_titles"| awk "NR == 1")
Title=$(cat "$tracks_titles"| awk "NR == 2")
echo "$trackpose    |$Title" >> tmp/track_menu_select
done


#!/bin/bash
prompt="N# |Trk pos |   Choose the N# of the corresponding track"
options=( $(cat tmp/track_menu_select) )

PS3="$prompt "
select chosen_track in "${options[@]}" "Quit" ; do
    if (( REPLY == 1 + ${#options[@]} )) ; then
        exit

    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        echo  "${orange}You chose "$chosen_track"_Song_info.txt $REPLY"
        break

    else
        echo "Invalid option. Try another one."
    fi
done
track_choice=$(echo "$chosen_track"| awk '{print $1}')
TrackTitle==$(echo "$chosen_track"| awk -F'|' '{print $2}')

echo "$TrackTitle" | sed 's/\$/USD/g' | sed "s/\&amp;/'/g"> diskinfo/TrackName
echo "TrackTitle=\$(cat diskinfo/TrackName)" >> tmp/tmp_Bash
