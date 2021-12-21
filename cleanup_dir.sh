#!/bin/bash
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
parentdir="$(dirname "$dir")"
if [ -f output.txt ]
then
rm output.txt
fi
find ./ -name "*.csv" -o -name "*.html" |sed 's/\/\//\//g'|sed 's/\.\///g' | awk '!/Album_ADDRESS.csv/'| awk '!/_info_Artist/' | awk '!/DISCOGSID.csv/'>> output.txt
IFS=$'\n' # split only on newlines
set -f    # disable globbing


for line in $(cat output.txt)
do
#echo "$nodeaudio" | grep -v *Album_ADDRESS.csv | xargs rm
rm "$line"
#echo "$line" | grep -v *Album_ADDRESS.csv | xargs rm
echo "$green################################################################################
# WORKING IN$white $line directory$green
################################################################################"
#echo "$directory"
done
#find "$directory" -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif"   | sed 's/\/\//\//g' > tmp/listtmp.txt

