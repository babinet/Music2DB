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
if [ -f ALLLLL.txt ]
then
rm ALLLLL.txt
fi
if [ -f ALLLLL-with-Path.csv ]
then
rm ALLLLL-with-Path.csv
fi


#de 80000001 à 80769734

# Get the number of collumn
#awk -F'|' '{print NF; exit}' file


find /Volumes/Music/_____OK -name _Album_AUDIO_IMPORT.csv | sed 's/\/\//\//g' > Nodes.txt

IFS=$'\n'       # Processing line
set -f          # disable globbing
for goodheader in $(cat Nodes.txt)
do

sourceFolder=$(dirname "$goodheader")
headerNumber=$(awk -F'|' '{print NF; exit}' "$goodheader")
destinationfolderTMP=$(echo "$goodheader" |awk -F'_____OK' '{print "/Volumes/MUSIC_OUT/MUSIC_DEF/_Out_GOOD_HEADERS"$2}')
destinationfolderGoodLength=$(dirname "$destinationfolderTMP")
destGood=$(dirname "$destinationfolderGoodLength")
#
destinationfolderBadTMP=$(echo "$goodheader" |awk -F'_____OK' '{print "/Volumes/MUSIC_OUT/MUSIC_DEF/_Out_BAD_HEADERS"$2}')
destinationfolderBad=$(dirname "$destinationfolderBadTMP")
destBad=$(dirname "$destinationfolderBad")
JustTheFile=$(echo "$goodheader" | awk '{print $NF}' FS=/ )
if [ "$headerNumber" == "87" ]
then
#echo $headerNumber
mkdir -p "$destGood"
cp -R "$sourceFolder" "$destGood"
else
mkdir -p "$destBad"
cp -R "$sourceFolder" "$destBad"
fi

done



#
#IFS=$'\n'       # Processing line
#set -f          # disable globbing
#for nodeiddupes in $(cat Nodes.txt)
#do
#
#cat "$nodeiddupes" |sed '1d' >> ALLLLL.txt
#done
#
#IFS=$'\n'       # Processing line
#set -f          # disable globbing
#for alllineid in $(cat ALLLLL.txt)
#do
#echo "$nodeiddupes|$alllineid" >> ALLLLL-with-Path.csv
#
#done
#
#
#awk -F'|' 'a[$31]++{print $0}' ALLLLL-with-Path.csv > _Out.txt
