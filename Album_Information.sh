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
echo "${bg_blue}${white}---> JE SUIS                                          : Album_Information.sh  <---${reset}"

source tmp/tmp_Bash

######## CREDIT ALBUM BEGIN

if [ -f "$Path2album"/_album_info/credits2taxonomyAlbum.csv ]
then
echo "${white}---> Credits & label information are present in       : ${orange}"$Path2album"/_album_info/credits2taxonomyAlbum.csv${white}"
else
if [ -f tmp/artistcreditTMP ]
then
rm tmp/artistcreditTMP
fi
#Credits
creditString=$(echo "id=\"release-credits")
if grep -q "$creditString" "$Path2album"/_album_info/ALBUM_Page.html
then
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
\/artist\//g'| awk '/\artist\//'|awk -F'/artist/' '{print $2}' |awk -F'>' '{print $2}'|awk -F'<' '{print $1}'| sed 's/\&amp;/\&/g')
LineArtist=$(echo "$lineofjob"| sed 's/\/artist\//\
\/artist\//g'|awk '/artist/' )
echo "$personName personName $addresspesonofthejob addresspesonofthejob $ArtistTID ArtistTID $lineofjob lineofjob
$white $LineArtist"

# Loop List artist csv
IFS=$'\n'       # Processing lines
set -f          # disable globbing
for artistinfo in $(echo -e "$LineArtist")
do
artistURL=$(echo "$artistinfo"|awk -F'"' '{print $1}'| sed 's/ \//\//g' )

artistID4list=$(echo "$artistinfo"|awk -F'/artist/' '{print $2}'|awk -F'"' '{print $1}')

artistTID4list=$(echo "$artistinfo"|awk -F'/artist/' '{print $2}'|awk -F'-' '{print $1}')
artistName4list=$(echo "$artistinfo"|awk -F'/artist/' '{print $2}'|awk -F'>' '{print $2}'|awk -F'<' '{print $1}'| sed 's/\&amp;/\&/g')
echo "${white}---> Artist / producer / etc                          : ${orange}$artistURL|$artistID4list|$artistTID4list|$artistName4list"
echo "$artistURL|$artistID4list|$artistTID4list|$artistName4list"|awk '/\/artist\//' >> tmp/artistCreditlListTMP
done

done

# Credits compile
echo "job|ArtistTID" > "$Path2album"/_album_info/credits2taxonomyAlbum.csv
cat tmp/artistcreditTMP |sed '1d' >> "$Path2album"/_album_info/credits2taxonomyAlbum.csv


echo "Artist-address|ArtistID|Artist_TID|Artist" > "$Path2album"/_album_info/credits_Artiss_list.csv
cat tmp/artistCreditlListTMP | sed 's/\[31m//g'| sed 's/\[97m//g'|sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'>> "$Path2album"/_album_info/credits_Artiss_list.csv
IFS=$'\n'       # Processing line
set -f          # disable globbing
# Album Job Loop
countjob='0'
cat "$Path2album"/_album_info/credits2taxonomyAlbum.csv | sed '1d' | while read thelineartist
do
countjob=$(( countjob+1 ))
echo "Job_"$countjob"|ArtistTID_"$countjob"
$thelineartist" |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' > tmp/job_"$countjob".csv
done





else
echo "${red}---> credits information is NOT there!"
fi
fi

######## CREDIT ALBUM FIN



#compagnies
compagniesLignes=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'|awk -F'id="release-companies' '{print $2}' |awk -F'<ul' '{print $2}'|awk -F'</ul>' '{print $1}'| sed 's/<li/\
<li/g' |awk NF)
#Release note
releaseNoteString=$(echo "id=\"release-notes")
if grep -q "$releaseNoteString" "$Path2album"/_album_info/ALBUM_Page.html
then
echo "${green}---> Release notes information are there!"

releasenoteslines=$(cat "$Path2album"/_album_info/ALBUM_Page.html |tr '\n' ' ' |awk -F'release-notes' '{print $2}' |awk -F'</section>' '{print $1}' |tr '\n' ' ' |sed 's/<br>\n//g'|awk -F'<div ' '{print $2}'|awk -F'<div>' '{print $2}' |tr -d '\r'|awk -F'</div>' '{print $1}' )
echo "releasenoteslines
$releasenoteslines" |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' > "$Path2album"/_album_info/releaseNote.csv
ReleaseNote=$(cat "$Path2album"/_album_info/releaseNote.csv| awk  'NR == 2')
else
echo "${red}---> Release notes information was not found!"
echo "releasenoteslines
" > "$Path2album"/_album_info/releaseNote.csv
fi



#Barcode
BarcodeeString=$(echo "id=\"release-barcodes")
if grep -q "$BarcodeeString" "$Path2album"/_album_info/ALBUM_Page.html
then
echo "${green}---> Barcode information are there!"
barcodelines=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'|awk -F'id="release-barcodes' '{print $2}' |awk -F'<ul' '{print $2}'|awk -F'</ul>' '{print $1}'| sed 's/<li/\
<li class=\"list-group-item\"/g' |awk NF |tr -d '\n'|awk '{print $0"</ul>"}'| sed 's/class="simple_iPiaF"/<ul class=\"list-group\"/g')
echo "barcodelines
$barcodelines" |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g'|sed s'/|/•/g' > "$Path2album"/_album_info/barcodelines.csv
else
echo "${red}---> Barcode information are not there!"
echo "barcodelines
" > "$Path2album"/_album_info/barcodelines.csv
fi




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

mkdir -p "$Path2album"/_album_info/CSVs tmp
# Get Master Information
MasterAlbumAddress=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' | awk -F'id="release-other-versions"' '{print $2}' |sed 's/\/fr\/master/\/master/g' |awk -F'href="/master' '{print $2}'| awk -F'"' '{print "https://discogs.com/master"$1}')
# > diskinfo/Tracks_temp.html
echo "${white}---> The address of the master is                     : ${orange}$MasterAlbumAddress"
if [ -f "$Path2album"/_album_info/_MASTER_ALBUM_Page.html ]
then
echo "${green}---> The master html file is already downloaded in    : ${orange}"$Path2album"/_album_info/_MASTER_ALBUM_Page.html"
else
curl -o "$Path2album"/_album_info/_MASTER_ALBUM_Page.html -LOs "$MasterAlbumAddress"
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
cat ""$Path2album"/_album_info/_MASTER_ALBUM_Page.html"|tr -d '\n' |awk -F'<div class="head">Notes:</div>' '{print $2}'|awk -F'<div class="content">' '{print $2}' |awk -F'</div>' '{print $1}'|awk NF| sed 's/\&quot;/"/g'|sed s'/|/•/g' >> "$Path2album"/_album_info/CSVs/NotesMaster.csv
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
LabeName=$(echo "$labelline"| awk NF| awk -F'/label/' '{print $2}'| awk -F'">' '{print $2}' | awk -F'</a>' '{print $1}'|sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g' |sed 's/&amp;/\&/g')
LabeCatalogNumber=$(echo "$labelline"| awk NF| awk -F'> – ' '{print $2}'| awk -F'<' '{print $1}' )
LabeURL=$(echo "$labelline"| awk NF| awk '/\/label\//'| awk -F'/label/' '{print "/label/"$2}'| awk -F'"' '{print $1}' )
echo ""$LabeID"|"$LabeName"|"$LabeTID"|"$LabeCatalogNumber"|"$LabeURL"" >> tmp/tempLabelTMP
done
if [ -f tmp/tempLabelTMP ]
then
echo "LabeID|LabeName|LabeTID|LabeCatalogNumber|LabeURL" > "$Path2album"/_album_info/CSVs/Labels.csv
cat tmp/tempLabelTMP |sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'| sed 's/&amp;/\&/g' >> "$Path2album"/_album_info/CSVs/Labels.csv
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
cat tmp/tempGenreTMP |sed "s/&#x27;/'/g"| sed 's/&amp;/\&/g'|sed 's/\&quot;/"/g' >> "$Path2album"/_album_info/CSVs/Genres.csv
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
cat tmp/tempStyleTMP |sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'>> "$Path2album"/_album_info/CSVs/Styles.csv
fi
fi

# Release tracks Information

CurrentReleaseYear=$(cat tmp/BasicInformation.txt | tr -d '\n'| awk -F'<tbody>' '{print $1}'| awk -F'year=' '{print $2}'| awk -F'"' '{print $1}' )
CurrentReleaseDate=$(cat tmp/BasicInformation.txt |tr -d '\n'|awk -F'<time' '{print $2}'|awk -F'dateTime="' '{print $2}'| awk -F'"' '{print $1}')

echo "ReleaseYear
$CurrentReleaseYear" > "$Path2album"/_album_info/CSVs/ReleaseYear.csv

echo "${white}---> Current release year of the release              : ${orange}"$CurrentReleaseYear


if [ "$CurrentReleaseDate" == "" ]
then
echo "${red}---> date is empty"
echo "ReleaseDate
" > "$Path2album"/_album_info/CSVs/ReleaseDate.csv
else
input="$CurrentReleaseDate"
re='^[[:digit:]]{4}$'
if [[ $input =~ $re ]]; then
echo "${white}---> Current release date of the release              : ${red}"$CurrentReleaseDate""
echo "${white}---> Changing date to                                 : ${orange}"$CurrentReleaseDate"-01-01"
echo "ReleaseDate
"$CurrentReleaseDate"-01-01" > "$Path2album"/_album_info/CSVs/ReleaseDate.csv
else
echo "ReleaseDate
$CurrentReleaseDate" > "$Path2album"/_album_info/CSVs/ReleaseDate.csv
echo "${white}---> ReleaseDate is                                   : ${orange}$CurrentReleaseDate"
fi
fi


if [ -f "$Path2album"/_album_info/jobe_Album.csv ]
then
echo "${white}---> Credit job information aready compiled           : ${orange}"$Path2album"/_album_info/jobe_Album.csv"

else
echo "${white}---> computing job information in                     : ${orange}"$Path2album"/_album_info/jobe_Album.csv"
paste -d '|' tmp/job_10.csv tmp/job_9.csv tmp/job_8.csv tmp/job_7.csv tmp/job_6.csv tmp/job_5.csv tmp/job_4.csv tmp/job_3.csv tmp/job_2.csv tmp/job_1.csv > "$Path2album"/_album_info/jobe_Album.csv
fi

CreditAlbum=$(cat "$Path2album"/_album_info/jobe_Album.csv| awk  'NR == 2')


#Format type / Release type
if [ -f "$Path2album"/_album_info/CSVs/CSVs/info_support.csv ]
then
SupportTypeRelease=$(cat $Path2album/_album_info/CSVs/info_support.csv| awk  'NR == 2')
echo "SupportTypeRelease=\$(cat \"\$Path2album\"/_album_info/CSVs/info_support.csv| awk  'NR == 2')" >> tmp/tmp_Bash
echo "${green}---> Fromat & release information are present in      :${orange} "$Path2album"/_album_info/CSVs/CSVs/info_support.csv"
echo "${white}---> Fromat & release information are present in      :${orange} $SupportTypeRelease"
else
FormatString=$(echo "class=\"format_item_3SAJn")
if [ -f tmp/releaseinfo.tmp ]
then
rm tmp/releaseinfo.tmp
fi
if grep -q "$FormatString" "$Path2album"/_album_info/ALBUM_Page.html
then
echo "${green}---> Fromat information are present in the html !"
Formatlines=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n'|awk -F'table_1fWaB' '{print $2}'|awk -F'</tbody>' '{print $1}' | sed 's/<div class="format_item_3SAJn"/\
<div class="format_item_3SAJn"/g' |awk '/class="format_item_3SAJn"/'|awk -F'</div>' '{print $1}')

IFS=$'\n'       # Processing line
set -f          # disable globbing
for lineFrmat in $(echo "$Formatlines")
do
Supports=$(echo "$lineFrmat" |awk -F'<a' '{print $2}'|awk -F'>' '{print $2}' |awk -F'<' '{print $1}')
TypeRelesae=$(echo "$lineFrmat" |awk -F'</a>, ' '{print $2}'|sed 's/<!-- -->//g' | awk -F'<' '{print $1}'| sed 's/, /@/g')

echo "$Supports|$TypeRelesae" >> tmp/releaseinfo.tmp
done
else
echo "${red}---> Fromat information are not there!"
echo "Support_Type|ReleaseType
" > "$Path2album"/_album_info/CSVs/info_support.csv
fi

TypeRelease=$(cat tmp/releaseinfo.tmp |awk -F'|' '{print $2}'|tr '\n' '@'|sed 's/.$//'|tr '@' '\n' |awk '!seen[$0]++'|tr '\n' '@'|sed 's/.$//')
support=$(cat tmp/releaseinfo.tmp |awk -F'|' '{print $1}'|awk '!seen[$0]++'|tr '\n' '@'|sed 's/.$//')

echo "Support_Type|ReleaseType
$support|$TypeRelease" > tmp/info_support.csv
cat tmp/info_support.csv | sed 's/\&quot;/\"/g' > "$Path2album"/_album_info/CSVs/info_support.csv

echo "SupportTypeRelease=\$(cat \"\$Path2album\"/_album_info/CSVs/info_support.csv| awk  'NR == 2')" >> tmp/tmp_Bash

fi







#for uri in $(cat /Volumes/CATACOMBES_IMAGES/M2DB/_Output/_AUDIOFILE_IMPORT.txt); do echo ${white}$uri; red=`tput setaf 1`; echo ${red} $uri | awk -F'private' '{print "private"$2}'| awk -F''\''' '{print $1}'| awk '{print length}'; done
