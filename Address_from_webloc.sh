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

mkdir -p tmp
find . -name *.webloc > tmp/webloc
IFS=$'\n'       # Processing line
set -f          # disable globbing

#mkdir -p _Output
for allwave in $(cat tmp/webloc| awk NF)
do
theparent=$(dirname "$allwave")
echo "$red$allwave$white"
# WatchOut Contro Chars
Address=$(cat -v "$allwave" | awk -F'https' '{print "https"$2}'|awk -F'^' '{print $1}' |sed 's/<\/string>//g'|awk NF)
echo "$white $Address"
echo $purple $theparent
mkdir -p "$theparent"/_album_info
echo "Album_address
$Address" > "$theparent"/_album_info/Album_ADDRESS.csv
done
