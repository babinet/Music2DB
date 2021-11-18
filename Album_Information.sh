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

echo "${bg_blue}${white}---> Hello I am Album_Information.sh${reset}"

source tmp/tmp_Bash

######## CREDIT ALBUM BEGIN
echo $purple DEBUG 01

if [ -f "$Path2album"/_album_info/credits2taxonomyAlbum.csv ]
then
echo $purple DEBUG 01 2
echo "${white}---> Credits & label information are alreedy processed for this disc : ${orange}"$Path2album"/_album_info/credits2taxonomyAlbum.csv${white}"
else
#if [ -f tmp/artistcreditTMP ]
#then
#rm tmp/artistcreditTMP
#fi
echo $purple DEBUG 02
#Credits
creditString=$(echo "id=\"release-credits")
echo $creditString
echo $purple DEBUG 03
if grep -q "$creditString" "$Path2album"/_album_info/ALBUM_Page.html
then
echo $purple DEBUG 04
echo "${green}---> credits information is there!"
Creditslines=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'|awk -F'id="release-credits' '{print $2}' |awk -F'<ul' '{print $2}'|awk -F'</ul>' '{print $1}'| sed 's/<li/\
<li/g' |awk NF)
echo "${white}---> saucissonnage des credits / artist name / artist TID / artist Address"
IFS=$'\n'       # Processing lines
set -f          # disable globbing
for creditline in $(echo "$Creditslines")
do
lineofjob=$(echo "$creditline"| cut -d'>' -f3-)
ArtistTID=$(echo "$lineofjob"|sed 's/\/artist\//\
\/artist\//g'| awk -F'/artist/' '{print $2}'| awk -F'-' '{print $1}'| tr '\n' '@'|sed 's/@$//'| cut -c 2-)
typeofjob=$(echo "$lineofjob"| awk -F'<' '{print $1}')
addresspesonofthejob=$(echo "$lineofjob"| sed 's/\/artist\//\
\/artist\//g'| awk '/\artist\//'|awk -F'"' '{print $1}')
echo "$typeofjob|$ArtistTID" >> tmp/artistcreditTMP
personName=$(echo "$lineofjob"| sed 's/\/artist\//\
\/artist\//g'| awk '/\artist\//'|awk -F'/artist/' '{print $2}' |awk -F'>' '{print $2}'|awk -F'<' '{print $1}')
LineArtist=$(echo "$lineofjob"| sed 's/\/artist\//\
\/artist\//g'|awk '/artist/' )

echo $purple DEBUG 05
# Loop List artist csv
IFS=$'\n'       # Processing lines
set -f          # disable globbing
for artistinfo in $(echo -e "$LineArtist")
do
artistURL=$(echo "$artistinfo"|awk -F'"' '{print $1}')

artistID4list=$(echo "$artistinfo"|awk -F'/artist/' '{print $2}'|awk -F'"' '{print $1}')

artistTID4list=$(echo "$artistinfo"|awk -F'/artist/' '{print $2}'|awk -F'-' '{print $1}')
artistName4list=$(echo "$artistinfo"|awk -F'/artist/' '{print $2}'|awk -F'>' '{print $2}'|awk -F'<' '{print $1}')
echo "$whithe ARTIST CREDITS $red$artistURL|$white$artistID4list|$artistTID4list|$artistName4list"
echo "$artistURL|$artistID4list|$artistTID4list|$artistName4list"|awk '/\/artist\//' >> tmp/artistCreditlListTMP
done

done

# Credits compile
echo "job|ArtistTID" > "$Path2album"/_album_info/credits2taxonomyAlbum.csv
cat tmp/artistcreditTMP |sed '1d' >> "$Path2album"/_album_info/credits2taxonomyAlbum.csv


echo "Artist-address|ArtistID|Artist_TID|Artist" > "$Path2album"/_album_info/credits_Artiss_list.csv
cat tmp/artistCreditlListTMP | sed 's/\[31m//g'| sed 's/\[97m//g'>> "$Path2album"/_album_info/credits_Artiss_list.csv




countjob='0'
cat "$Path2album"/_album_info/credits2taxonomyAlbum.csv | sed '1d' | while read thelineartist
do
countjob=$(( countjob+1 ))

echo "Job_"$countjob"|ArtistTID_"$countjob"
$thelineartist" |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' > tmp/job_"$countjob".csv
done


if [ -f tmp/job_1.csv ]
then
echo "tmp/job_1.csv was found"
else
echo "Job_1|ArtistTID_1
|" > tmp/job_1.csv
fi

if [ -f tmp/job_2.csv ]
then
echo "tmp/job_2.csv was found"
else
echo "Job_2|ArtistTID_2
|" > tmp/job_2.csv
fi

if [ -f tmp/job_3.csv ]
then
echo "tmp/job_3.csv was found"
else
echo "Job_3|ArtistTID_3
|" > tmp/job_3.csv
fi

if [ -f tmp/job_4.csv ]
then
echo "tmp/job_4.csv was found"
else
echo "Job_4|ArtistTID_4
|" > tmp/job_4.csv
fi

if [ -f tmp/job_5.csv ]
then
echo "tmp/job_5.csv was found"
else
echo "Job_5|ArtistTID_5
|" > tmp/job_5.csv
fi

if [ -f tmp/job_6.csv ]
then
echo "tmp/job_6.csv was found"
else
echo "Job_6|ArtistTID_6
|" > tmp/job_6.csv
fi

if [ -f tmp/job_7.csv ]
then
echo "tmp/job_7.csv was found"
else
echo "Job_7|ArtistTID_7
|" > tmp/job_7.csv
fi

if [ -f tmp/job_8.csv ]
then
echo "tmp/job_8.csv was found"
else
echo "Job_8|ArtistTID_8
|" > tmp/job_8.csv
fi

if [ -f tmp/job_9.csv ]
then
echo "tmp/job_9.csv was found"
else
echo "Job_9|ArtistTID_9
|" > tmp/job_9.csv
fi

if [ -f tmp/job_10.csv ]
then
echo "tmp/job_10.csv was found"
else
echo "Job_10|ArtistTID_10
|" > tmp/job_10.csv
fi

paste -d '|' tmp/job_10.csv tmp/job_9.csv tmp/job_8.csv tmp/job_7.csv tmp/job_6.csv tmp/job_5.csv tmp/job_4.csv tmp/job_3.csv tmp/job_2.csv tmp/job_1.csv > "$Path2album"/_album_info/jobe_Album.csv
CreditAlbum=$(cat "$Path2album"/_album_info/jobe_Album.csv| awk  'NR == 2')



echo $purple DEBUG 06




else
echo "${red}---> credits information is NOT there!"
fi
fi

######## CREDIT ALBUM FIN
#compagnies
echo $purple DEBUG A
compagniesLignes=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'|awk -F'id="release-companies' '{print $2}' |awk -F'<ul' '{print $2}'|awk -F'</ul>' '{print $1}'| sed 's/<li/\
<li/g' |awk NF)
#Release note
releasenoteslines=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'|awk -F'id="release-notes' '{print $2}' |awk -F'<div>' '{print $2}'|awk -F'</div>' '{print $1}')
#Barcode
barcodelines=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'|awk -F'id="release-barcodes' '{print $2}' |awk -F'<ul' '{print $2}'|awk -F'</ul>' '{print $1}'| sed 's/<li/\
<li/g' |awk NF)
echo $purple DEBUG 07
echo "releasenoteslines
$releasenoteslines" |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' |tr -d '\n' > "$Path2album"/_album_info/releaseNote.csv
echo "barcodelines
$barcodelines" |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' |tr -d '\n' > "$Path2album"/_album_info/barcodelines.csv


ReleaseNote=$(cat "$Path2album"/_album_info/releaseNote.csv| awk  'NR == 2')
BarCode=$(cat "$Path2album"/_album_info/barcodelines.csv| awk  'NR == 2')
echo $purple DEBUG 08
