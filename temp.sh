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


Path2album="/Volumes/CATACOMBES_IMAGES/M2DB/_Source/Disc_1"
mkdir -p "$Path2album"/_album_info/CSVs tmp
# Get Master Information
MasterAlbumAddress=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' | awk -F'id="release-other-versions"' '{print $2}' |sed 's/\/fr\/master/\/master/g' |awk -F'href="/master' '{print $2}'| awk -F'"' '{print "https://discogs.com/master"$1}')
# > diskinfo/Tracks_temp.html
echo "${white}---> The address of the master is                     : ${orange}$MasterAlbumAddress"
if [ -f ""$Path2album"/_album_info/_MASTER_ALBUM_Page.html" ]
then
echo "${green}---> The master html file is already downloaded in    : ${orange}"$Path2album"/_album_info/_MASTER_ALBUM_Page.html"
else
curl -o ""$Path2album"/_album_info/_MASTER_ALBUM_Page.html" -LOs "$MasterAlbumAddress"
fi

# Master Year
if [ -f "$Path2album"/_album_info/CSVs/YearMaster.csv ]
then
echo "${green}---> Year of the Master has been found in             : ${orange}"$Path2album"/_album_info/CSVs/YearMaster.csv"
YearOfTheAlbum=$(cat "$Path2album"/_album_info/CSVs/YearMaster.csv| awk  'NR == 2')
else
YearOfTheAlbum=$(cat ""$Path2album"/_album_info/_MASTER_ALBUM_Page.html"|tr -d '\n' | awk -F'id="profile_title"' '{print $2}'| awk -F'id="tracklist"' '{print $1}' | awk -F'&year=' '{print $2}' | awk -F'"' '{print $1}')
echo "YearOfTheAlbum
$YearOfTheAlbum" > "$Path2album"/_album_info/CSVs/YearMaster.csv
fi
echo "${white}---> Master release year of the album is              : ${orange}$YearOfTheAlbum"
# Master Note
if [ -f "$Path2album"/_album_info/CSVs/NotesMaster.csv ]
then
echo "${green}---> Notes on the Master has been found in            : ${orange}"$Path2album"/_album_info/CSVs/NotesMaster.csv"
else
echo "NotesMaster" > "$Path2album"/_album_info/CSVs/NotesMaster.csv
cat ""$Path2album"/_album_info/_MASTER_ALBUM_Page.html"|tr -d '\n' |awk -F'<div class="head">Notes:</div>' '{print $2}'|awk -F'<div class="content">' '{print $2}' |awk -F'</div>' '{print $1}'|awk NF| sed 's/\&quot;/"/g' >> "$Path2album"/_album_info/CSVs/NotesMaster.csv
cat "$Path2album"/_album_info/CSVs/NotesMaster.csv | awk  'NR == 2'
fi
# Release Information

cat "$Path2album"/_album_info/ALBUM_Page.html |tr -d '\n'|awk -F'"info_23nnx"' '{print $2}'|awk -F'<section>' '{print $1}'|awk -F'<tbody>' '{print $2}' |awk -F'</tbody>' '{print $1}'> tmp/BasicInformation.txt

#Label
#Format
# Tableau
TabeleauTR=$(cat tmp/BasicInformation.txt|sed 's/<th/\
<th/g')
if [ -f tmp/tempLabel ]
then
rm tmp/tempLabel
fi


if [ -f "$Path2album"/_album_info/CSVs/Labels.csv ]
then
echo "${green}---> Label information has been found in              : ${orange}"$Path2album"/_album_info/CSVs/Labels.csv"
else
echo "${white}---> Processing Label(s) information                  : ${orange}$YearOfTheAlbum"
#Label
IFS=$'\n'       # Processing line
set -f          # disable globbing
for labels in $(echo "$TabeleauTR")
do
Labels=$(echo "$labels"| awk NF |awk '/>Label</'| sed 's/<a href="\//\
<a href="\//g'|awk '/\/label\//'| awk NF )
echo "$Labels" | awk NF>> tmp/tempLabel
done

if [ -f tmp/tempLabelTMP ]
then
rm tmp/tempLabelTMP
fi
IFS=$'\n'       # Processing line
set -f          # disable globbing
for labelline in $(cat tmp/tempLabel)
do
LabeID=$(echo "$labelline"| awk NF| awk -F'/label/' '{print $2}'| awk -F'"' '{print $1}' )
LabeTID=$(echo "$labelline"| awk NF| awk -F'/label/' '{print $2}'| awk -F'-' '{print $1}' )
LabeName=$(echo "$labelline"| awk NF| awk -F'/label/' '{print $2}'| awk -F'">' '{print $2}' | awk -F'</a>' '{print $1}')
LabeCatalogNumber=$(echo "$labelline"| awk NF| awk -F'> – ' '{print $2}'| awk -F'<' '{print $1}' )
LabeURL=$(echo "$labelline"| awk NF| awk '/\/label\//'| awk -F'/label/' '{print "/label/"$2}'| awk -F'"' '{print $1}' )
echo ""$LabeID"|"$LabeName"|"$LabeTID"|"$LabeCatalogNumber"|"$LabeURL"" >> tmp/tempLabelTMP
done
if [ -f tmp/tempLabelTMP ]
then
echo "LabeID|LabeName|LabeTID|LabeCatalogNumber|LabeURL" > "$Path2album"/_album_info/CSVs/Labels.csv
cat tmp/tempLabelTMP >> "$Path2album"/_album_info/CSVs/Labels.csv
fi
fi

#Genre
if [ -f "$Path2album"/_album_info/CSVs/Genres.csv ]
then
echo "${green}---> Genre information has been found in              : ${orange}"$Path2album"/_album_info/CSVs/Genres.csv"
else
echo "${white}---> Processing Genre(s) information                  "
if [ -f tmp/tempGenre ]
then
rm tmp/tempGenre
fi
IFS=$'\n'       # Processing line
set -f          # disable globbing
for genres in $(echo "$TabeleauTR")
do
Genres=$(echo "$genres"| awk NF |awk '/>Genre</'| sed 's/<a href="\//\
<a href="\//g'|awk '/\/genre\//'| awk NF )
echo "$Genres" | awk NF>> tmp/tempGenre
done

if [ -f tmp/tempGenreTMP ]
then
rm tmp/tempGenreTMP
fi
IFS=$'\n'       # Processing line
set -f          # disable globbing
for genrelline in $(cat tmp/tempGenre)
do
GenreName=$(echo "$genrelline"| awk NF| awk -F'/genre/' '{print $2}'| awk -F'">' '{print $2}' | awk -F'</a>' '{print $1}')
GenreURL=$(echo "$genrelline"| awk NF| awk '/\/genre\//'| awk -F'/genre/' '{print "/genre/"$2}'| awk -F'"' '{print $1}' )
echo "$GenreName|$GenreURL" >> tmp/tempGenreTMP
done
if [ -f tmp/tempGenreTMP ]
then
echo "Genre_Name|GenreURL" > "$Path2album"/_album_info/CSVs/Genres.csv
cat tmp/tempGenreTMP >> "$Path2album"/_album_info/CSVs/Genres.csv
fi
fi

#Style
if [ -f "$Path2album"/_album_info/CSVs/Styles.csv ]
then
echo "${green}---> Style information has been found in              : ${orange}"$Path2album"/_album_info/CSVs/Styles.csv"
else
echo "${white}---> Processing Style(s) information                  "
if [ -f tmp/tempStyle ]
then
rm tmp/tempStyle
fi
IFS=$'\n'       # Processing line
set -f          # disable globbing
for styles in $(echo "$TabeleauTR")
do
Styles=$(echo "$styles"| awk NF |awk '/>Style</'| sed 's/<a href="\//\
<a href="\//g'|awk '/\/style\//'| awk NF )
echo "$Styles" | awk NF>> tmp/tempStyle
done

if [ -f tmp/tempStyleTMP ]
then
rm tmp/tempStyleTMP
fi
IFS=$'\n'       # Processing line
set -f          # disable globbing
for stylelline in $(cat tmp/tempStyle)
do
StyleName=$(echo "$stylelline"| awk NF| awk -F'/style/' '{print $2}'| awk -F'">' '{print $2}' | awk -F'</a>' '{print $1}')
StyleURL=$(echo "$stylelline"| awk NF| awk '/\/style\//'| awk -F'/style/' '{print "/style/"$2}'| awk -F'"' '{print $1}' )

echo "$StyleName|$StyleURL" >> tmp/tempStyleTMP

done
if [ -f tmp/tempStyleTMP ]
then
echo "style_Name|StyleURL" > "$Path2album"/_album_info/CSVs/Styles.csv
cat tmp/tempStyleTMP >> "$Path2album"/_album_info/CSVs/Styles.csv
fi
fi

# Release tracks Information

CurrentReleaseYear=$(cat tmp/BasicInformation.txt | tr -d '\n'| awk -F'<tbody>' '{print $1}'| awk -F'year=' '{print $2}'| awk -F'"' '{print $1}' )
CurrentReleaseDate=$(cat tmp/BasicInformation.txt |tr -d '\n'|awk -F'<time' '{print $2}'|awk -F'dateTime="' '{print $2}'|awk -F'"' '{print $1}')
echo "${white}---> Current release year of the release              : ${orange}"$CurrentReleaseYear
echo "${white}---> Current release date of the release              : ${orange}"$CurrentReleaseDate




#cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' | tr -d '\r'|awk -F'release-tracklist' '{print $2}' |awk -F'</section>' '{print $1}' > diskinfo/Tracks_temp.html
#cat diskinfo/Tracks_temp.html
#for TheLineInfoOnTrack in $(cat diskinfo/temp2.html)
#do
#TrackLine=$(echo "$TheLineInfoOnTrack" |awk '/data-track-position='/|awk -F'</tr>' '{print $1}' |sed 's/<tr/\
#<tr/g' |tr -d '0' |awk NF)
#
##|awk -F'<td class="artist' '{print $2}'|awk -F'>' '{print $2}'
##TrackPostition=$(echo "$TrackLine" |awk -F'data-track-position="' '{print $2}'|awk -F'"' '{print $1}' |sed 's/<tr/\
##<tr/g')
##echo "$TrackPostition" |awk NF
#
#
#
#
#credits=$(echo "$TrackLine" | awk -F'<div class="credits_12-wp expanded_3odiy">' '{print $2}' | awk -F'aria-hidden="true">' '{print $1}' |sed 's/<\/span>,/\
#<\/span>,/g'|sed 's/<\/span> – <span/\
#/g'|sed 's/<div><span>/\
#/g'|awk NF |awk '{print $0}')
#
#
#echo "$credits"
#
#
#
#
#
#
#
#
#
#
#
#done
title="Medley"
mkdir -p diskinfo
cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'  |awk -F'<h3>Tracklist</h3>' '{print $2}'|awk -F'</ul>' '{print $1}' | sed 's/<tr/\
<tr/g' | awk '/<tr/' |sed "s/\&#x27;/'/g" |sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g' > diskinfo/only_tracks.txt
#
awk '/>Won'\''t Be Long</' diskinfo/only_tracks.txt
echo $red
awk '/<tr class="heading/' diskinfo/only_tracks.txt
