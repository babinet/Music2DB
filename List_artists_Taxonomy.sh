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
mkdir -p tmp

if [ -f tmp/tmp.csv ]
then
rm tmp/tmp.csv
fi
if [ -f tmp/tampon.txt ]
then
rm tmp/tampon.txt
fi
find . -name ALBUM_Page.html|sed 's/\/\//\//g'|sed 's/\.\///g' > tmp/Find_result
IFS=$'\n'       # Processing line
set -f          # disable globbing
for SourceRelease in $(cat tmp/Find_result)
do

cat "$SourceRelease" | tr -d '\n'| tr -d '\r'|awk -F '<h3>Tracklist' '{print $2}'|awk -F '<section id="release-recommendations"' '{print $1}' | awk '/\/artist\//'|sed 's/\/artist\//\
\/artist\//g'|awk NF| awk '/\/artist\//'| awk '/<\/a>/' |awk -F'</div>' '{print $1}'|awk NF >> tmp/tampon.txt
done


IFS=$'\n'       # Processing line
set -f          # disable globbing
for artistline in $(cat tmp/tampon.txt)
do
ArtistAddress=$(echo "$artistline"|awk -F'"' '{print $1}')

ArtistID=$(echo "$artistline" | awk -F'/artist/' '{print $2}'|awk -F'"' '{print $1}' )
ArtistTID=$(echo "$ArtistID" | awk -F'-' '{print $1}')
ArtistName=$(echo "$artistline"| awk -F'<' '{print $1}'| awk -F'>' '{print $2}')
echo "$ArtistAddress|$ArtistID|$ArtistTID|$ArtistName" >> tmp/tmp.csv
done

if [ -f tmp/TID_LIST.txt ]
then
echo "${red}A Tid list is present ans will be use to compare${white}"
else
if [ -f .server ]
then
servername=$(cat .server)
echo "${green}---> The server is : ${white}$servername"
SERVERNAME=$(cat .server)
else
read -p "${orange}Enter server address :" SERVERNAME
echo "$SERVERNAME" > .server
fi
curl -o tmp/tid.txt -LO "$SERVERNAME"/TID
# Cleanup
cat tmp/tid.txt | awk '!/</'|awk '!/>/' |awk '!/   * /' |awk '!/   x /'|awk NF > tmp/TID_LIST.txt
fi
# Suppression des tid déja importés
awk -F'|' 'NR==FNR{a[$3];next} !($3 in a)' tmp/TID_LIST.txt tmp/tmp.csv > tmp/temp2

echo "Artist-address|ArtistID|Artist_TID|Artist" > _ARTIST_2_IMPORT.csv
cat tmp/temp2 |awk '!seen[$0]++' >> _ARTIST_2_IMPORT.csv


awk -F'|' 'NR==FNR{a[$3];next} !($3 in a)' tmp/TID_LIST.txt _ARTIST.CSV > ___LISt-ARTIST.CSV
