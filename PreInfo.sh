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
echo "$bg_blue$white Hello I am Preinfo.sh$reset"

dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd "$dir"
mkdir -p tmp
for d in */
do
if [ -f tmp/listtmp.txt ]
then
rm tmp/listtmp.txt
fi
if [ -f tmp/songslistTMP.txt ]
then
rm tmp/songslistTMP.txt
fi


find "$d" -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif"   | sed 's/\/\//\//g' >> tmp/listtmp.txt

IFS=$'\n'       # Processing line
set -f          # disable globbing
for hello in $(cat tmp/listtmp.txt)
do
ffprobe "$hello" > tmp/temp.txt 2>&1
cat tmp/temp.txt |awk '/    ARTIST/'| awk -F'ARTIST          : ' '{print "ARTIST : "$2}' >> tmp/songslistTMP.txt
cat tmp/temp.txt |awk '/    ALBUM           : /'| awk -F'ALBUM           : ' '{print "ALBUM  : "$2}' >> tmp/songslistTMP.txt
cat tmp/temp.txt |awk '/    TITLE/'| awk -F'TITLE           : ' '{print "TITLE  : "$2}' >> tmp/songslistTMP.txt
cat tmp/temp.txt |awk '/    album           : /'| awk -F'    album           : ' '{print "ALBUM  : "$2}' >> tmp/songslistTMP.txt
cat tmp/temp.txt |awk '/    title           : /'| awk -F'    title           : ' '{print "TITLE  : "$2}' >> tmp/songslistTMP.txt
cat tmp/temp.txt |awk '/    artist          : /'| awk -F'    artist          : ' '{print "ARTIST : "$2}' >> tmp/songslistTMP.txt
echo "-----------------------------------------------------------------" >> tmp/songslistTMP.txt

done
cat tmp/songslistTMP.txt |awk NF > tmp/songslist.txt
echo "${white}---> Directory        :${orange}"$d""
cat tmp/songslist.txt
numberoftitles=$(cat tmp/songslist.txt | awk '/-----------------------------------------------------------------/' |wc -l |tr -d ' ')
echo "${white}---> Il y a "$numberoftitles" titres pour cest album"
read -p "${white}---> Discogs Address of the release ? ${orange}: " DiscogsAddress
mkdir -p "$d"/_album_info
echo "Addres_album" > "$d"/_album_info/Album_ADDRESS.csv
echo "$DiscogsAddress" | sed 's/fr\///g'  >> "$d"/_album_info/Album_ADDRESS.csv


done
