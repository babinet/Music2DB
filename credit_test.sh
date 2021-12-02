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


source tmp/tmp_Bash
if [ -f diskinfo/diskinfoDISCOGSID ]
then
diskinfoDISCOGSID=$(cat diskinfo/diskinfoDISCOGSID)
fi

if [ "$DISCOGSID" == "$diskinfoDISCOGSID" ]
then
echo "${bg_green}${white}---> Diskinfo already processed ! <---"
else
echo "${white}---> Processing tracks on diskinfo"
if [ -f diskinfo/tempo.txt ]
then
rm diskinfo/tempo.txt
fi

IFS=$'\n'       # Processing line
set -f          # disable globbing
for TheLineInfoOnTrack in $(cat diskinfo/temp2.html)
do
# TracTitle
ToloopAfter=$(echo "$TheLineInfoOnTrack" |sed 's/<div class="measure_17Kyu credits_12-wp" aria-hidden="true">/\
<div class="measure_17Kyu credits_12-wp" aria-hidden="true">/g' |awk '!/aria-hidden="true"/'|sed 's/<td class="artist_3zAQD">/\
<td class="artist_3zAQD">/g'| sed 's/\/artist\//\
\/artist\//g'| sed 's/<\/span><\/div><div>/\
<\/span><\/div><div>/g' |sed 's/credits_12-wp/\
credits_12-wp/g'|awk NF)
TrackTitle=$(echo "$TheLineInfoOnTrack" |awk '/<span class="trackTitle/' | awk -F'<span class="trackTitle_CTKp4">' '{print $2}'| awk -F'<' '{print $1}'|sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'|awk NF)
echo "Track_position_ROWSEP" >>diskinfo/tempo.txt
echo "$Track_position" |awk NF >>diskinfo/tempo.txt
echo "$TrackTitle" |awk NF >>diskinfo/tempo.txt
IFS=$'\n'       # Processing line
set -f          # disable globbing
for toloop in $(echo "$ToloopAfter")
do
Track_position=$(echo "$toloop" |awk -F'trackPos_2RCje">' '{print $2}'|awk -F'<' '{print $1}'|awk NF|sed 's/-0/-/g')
job=$(echo "$toloop"| awk -F'<div><span>' '{print $2}'|awk -F'<' '{print $1}'|awk NF|sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g')
artistAddress=$(echo "$toloop"| awk '/\artist\//' | awk -F'"' '{print $1}'|awk NF)
artistName=$(echo "$toloop"| awk '/\artist\//' |awk -F'link_15cpV">' '{print $2}'|awk -F'<' '{print $1}'|awk NF|sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'|awk '{print $0"NEWLINENEWLINE"}')
artistTID=$(echo "$toloop"| awk '/\artist\//' | awk -F'/artist/' '{print $2}'| awk -F'-' '{print $1}'|awk NF)

# SED Clean ASCI to utf8
# sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'
if [ "$job" == "" ]
then
echo "job is empty"
RS=""
else
echo "job is there"
RS="Job_ROW_SEPARATOR"
fi
echo "$purple$job"
echo "$TRS
$RS
$job
|$artistTID|$artistAddress|$artistName" |awk NF | awk '!/\|\|/' >>diskinfo/tempo.txt
done
done

#Just close the files after writing:
#awk -F, '{print > $2; close($2)}' test1.csv
awk '/Track_position_ROWSEP/{x="SongInfo_"++i;next}{print >> x;close(x)}' diskinfo/tempo.txt
mkdir -p diskinfo/SongInfo
IFS=$'\n'       # Processing line
set -f          # disable globbing
SongInfoSource=$(find ./ -name SongInfo_*|sed 's/.\/\///g')
for infocleaneup in $(echo "$SongInfoSource")
do
DiskSongNumber=$(cat "$infocleaneup"| awk  'NR == 1')
cat "$infocleaneup" | awk '!/./ || !seen[$0]++' |sed '/Job_ROW_SEPARATOR/q'|awk '!/Job_ROW_SEPARATOR/' > diskinfo/SongInfo/"$DiskSongNumber"_Song_info.txt
cat "$infocleaneup" |sed -n '/Job_ROW_SEPARATOR/,$p'|awk '!/Job_ROW_SEPARATOR/'|tr -d '\n' | sed 's/NEWLINENEWLINE/\
/g' |awk NF >> diskinfo/SongInfo/"$DiskSongNumber"_Song_info.txt
rm "$infocleaneup"
done
echo "$DISCOGSID" diskinfo/diskinfoDISCOGSID
fi

#Pour Chaque Track diskinfo/SongInfo/"$DiskSongNumber"_Song_info.txt
# Le Numero (Disk-SongNumber)
# awk 'NR == 1' diskinfo/SongInfo/"*"_Song_info.txt
# Le Nom de la track sur discogs
# awk 'NR == 2' diskinfo/SongInfo/"*"_Song_info.txt
# Les Rows avec Le job | le TID | l'address| le Nom human name
# Written-By|452687|/artist/452687-Sylvester-Stewart|S. Stewart
# awk '(NR>2)' diskinfo/SongInfo/*_Song_info.txt
#for all in diskinfo/SongInfo/*.txt; do cat "$all" |awk '(NR>2)'; done
