#!/bin/bash -e
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
cd "$dir"

echo "${WHITE}---> JE SUIS                    : ${green}Renumber_Track.sh"
echo "${white}---> Je renumerote les tags id3 des fichiers audio"
mkdir -p ../_ReNumber ../_Processed

read -p "put your file in ../_ReNumber" renum


find "../_ReNumber" -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif"   | sed 's/\/\//\//g' > tmp/listtprenum.txt
if [ -f tmp/listtprenum.txt ]
then
echo "${white}---> Looping through audio files"
IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for thefilelist in $(cat tmp/listtprenum.txt)
do
ParentDir2Albumtmp=$(dirname "$thefilelist")
ParentDir2Album=$(echo $ParentDir2Albumtmp| awk -F'/' '{print $3}'|tr ' ' '_')
echo $ParentDir2Album ParentDir2Album
mkdir -p ../_ReNumber/tmp
echo "${white}---> Processing file ffprobe      : ${orange}$thefilelist"
if [ -f "$thefilelist" ]
then
echo "${white}---> The filename is              :${orange} $thefilelist"




ffprobe "$thefilelist" > ../_ReNumber/tmp/temp_info.txt 2>&1
#cat ../_ReNumber/tmp/temp_info.txt
#awk '/track/' ../_ReNumber/tmp/temp_info.txt
extension="${thefilelist##*.}"
FileOutTMP="${thefilelist##*/}"
FileOut=$(echo "$FileOutTMP"|tr ' ' '_')

title=$(cat ../_ReNumber/tmp/temp_info.txt|awk '/title/'|awk -F'title           : ' '{print $2}')
echo "${white}---> the curent title is          :${orange} $title"
echo "$FileOut FileOutNoExt $FileOutTMP FileOutNoExtTMP"
read -p "${white}---> enter the new title          :${orange}" newtitle
read -p "${white}---> enter the new track N#       :${orange}" newtracknumber
echo "$purple                                   $newtracknumber"
echo "$purple                                   $newtitle"
mkdir -p ../_Processed/"$ParentDir2Album"


ffmpeg -i "$thefilelist" -c copy -metadata title="$newtitle" -metadata track="$newtracknumber" ../_Processed/"$ParentDir2Album"/"$newtracknumber"_"$FileOutNoExt"."$extension"





fi
rm -R ../_ReNumber/tmp
done
open ../_Processed
else
echo "${white}---> No result found"
fi







## Track
#if [ -f tmp/TRACK.csv ]
#then
#cat tmp/TRACK.csv | awk -F'/' '{print $1}' | sed 's/track/Track/g' | sed 's/TRACK/Track/g' > tmp/_album_info/tracktmp.csv
#mv tmp/_album_info/tracktmp.csv tmp/_album_info/current_track.csv
#tractNumberTMP=$(cat tmp/_album_info/current_track.csv | awk  'NR == 2')
#fi
#if [ -f tmp/track.csv ]
#then
#cat tmp/track.csv | awk -F'/' '{print $1}' | sed 's/track/Track/g' | sed 's/TRACK/Track/g' > tmp/_album_info/tracktmp.csv
#mv tmp/_album_info/tracktmp.csv tmp/_album_info/current_track.csv
#tractNumberTMP=$(cat tmp/_album_info/current_track.csv | awk  'NR == 2')
#fi
#if [ -f tmp/Track.csv ]
#then
#cat tmp/Track.csv | awk -F'/' '{print $1}' | sed 's/track/Track/g' | sed 's/TRACK/Track/g' > tmp/_album_info/tracktmp.csv
#mv tmp/_album_info/tracktmp.csv tmp/_album_info/current_track.csv
#tractNumberTMP=$(cat tmp/_album_info/current_track.csv | awk  'NR == 2')
#fi
#if [ -z "$tractNumberTMP" ]
#then
#echo "${bg_red}${white}---> There is no track N# :${orange} Enter manualy .eg:8
#${reset}${white}"
#read -p "Track Number : " ttracknumberinput
#echo "Track
#$ttracknumberinput" > tmp/current_track.csv
#cp tmp/current_track.csv tmp/_album_info/current_track.csv
#fi
