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

mkdir -p tmp


if [ -f tmp/temp_update_lines ]
then
rm tmp/temp_update_lines
fi

#Segments info
#1 = begining
#$(f["DiscNumber"]), $(f["traxNumber"]), $(f["Artist"]), $(f["Album_Title"]), $(f["CoverFID"]), $(f["TrackTitle"])
# 2 = Artists
# Artists patch ALBUMARTIST Replace Artist
# 3 = Segment1
# $(f["DISCTOTAL"]), $(f["TRACKTOTAL"]), $(f["Duration"]), $(f["Audio"])
# 4 = $Label1|$LabeCatalogNumber1|$Label2|$LabeCatalogNumber2|$Label3|$LabeCatalogNumber3
# 5 = $Segment2
# Segment2 = YEAR    Date    fileNoExt    Path2album    extension    FileSize    Genre    AlbumADDRESS    Album_TID    TheFileSoundID_fid    ID_DISCOGS    ImagesFID    NodeID    UUID    Artist_TID    Album_TID    AlbumURL    extension    TrackURL    FileOutNoExt    ISRC    compilation    compilationUUID    1_pers    1_info    2_pers    2_info    3_pers    3_info    4_pers    4_info    5_pers    5_info    6_pers    6_info    7_pers    7_info    8_pers    8_info    9_pers    9_info    10_pers    10_info    Job_10    ArtistTID_10    Job_9    ArtistTID_9    Job_8    ArtistTID_8    Job_7    ArtistTID_7    Job_6    ArtistTID_6    Job_5    ArtistTID_5    Job_4    ArtistTID_4    Job_3    ArtistTID_3    Job_2    ArtistTID_2    Job_1    ArtistTID_1    releasenoteslines    BarCode    MainArtistAddress

# end = YearMaster    Support_Type    ReleaseType    sufix_artist_group


# Convert "header with tabs "\t" to the right format for awk
# echo  "DiscNumber    traxNumber    Artist    Album_Title    CoverFID    TrackTitle    ALBUMARTIST    DISCTOTAL    TRACKTOTAL    Duration    Audio"  |sed s'/    /"]), \$(f["/g'|awk '{print "\$(f[\""$0"\"])"}'
#  |sed s'/    /"]), \$["/g'|awk '{print "\$(f[\""$0"\"])"}'

Path2album="/Volumes/MUSIC_OUT/Test"
find "$Path2album" -name *_NodeAudio.csv | sed 's/\/\//\//g' > tmp/NodeAudioInfoTMP
IFS=$'\n'
set -f
for theline in $(cat tmp/NodeAudioInfoTMP)
do

begining=$(awk -F'|' '
NR==1 {
    for (i=1; i<=NF; i++) {
        f[$i] = i
    }
}
{ print $(f["DiscNumber"]), $(f["traxNumber"]), $(f["Artist"]), $(f["Album_Title"]), $(f["CoverFID"]), $(f["TrackTitle"]) }' OFS='|' "$theline" | awk '(NR>1)')
#

Segment1=$(awk -F'|' '
NR==1 {
    for (i=1; i<=NF; i++) {
        f[$i] = i
    }
}
{ print $(f["DISCTOTAL"]), $(f["TRACKTOTAL"]), $(f["Duration"]), $(f["Audio"]) }' OFS='|' "$theline" | awk '(NR>1)')
#

Segment2=$(awk -F'|' '
NR==1 {
    for (i=1; i<=NF; i++) {
        f[$i] = i
    }
}
{ print $(f["YEAR"]), $(f["Date"]), $(f["fileNoExt"]), $(f["Path2album"]), $(f["extension"]), $(f["FileSize"]), $(f["Genre"]), $(f["AlbumADDRESS"]), $(f["Album_TID"]), $(f["TheFileSoundID_fid"]), $(f["ID_DISCOGS"]), $(f["ImagesFID"]), $(f["NodeID"]), $(f["UUID"]), $(f["Artist_TID"]), $(f["Album_TID"]), $(f["AlbumURL"]), $(f["extension"]), $(f["TrackURL"]), $(f["FileOutNoExt"]), $(f["ISRC"]), $(f["compilation"]), $(f["compilationUUID"]), $(f["1_pers"]), $(f["1_info"]), $(f["2_pers"]), $(f["2_info"]), $(f["3_pers"]), $(f["3_info"]), $(f["4_pers"]), $(f["4_info"]), $(f["5_pers"]), $(f["5_info"]), $(f["6_pers"]), $(f["6_info"]), $(f["7_pers"]), $(f["7_info"]), $(f["8_pers"]), $(f["8_info"]), $(f["9_pers"]), $(f["9_info"]), $(f["10_pers"]), $(f["10_info"]), $(f["Job_10"]), $(f["ArtistTID_10"]), $(f["Job_9"]), $(f["ArtistTID_9"]), $(f["Job_8"]), $(f["ArtistTID_8"]), $(f["Job_7"]), $(f["ArtistTID_7"]), $(f["Job_6"]), $(f["ArtistTID_6"]), $(f["Job_5"]), $(f["ArtistTID_5"]), $(f["Job_4"]), $(f["ArtistTID_4"]), $(f["Job_3"]), $(f["ArtistTID_3"]), $(f["Job_2"]), $(f["ArtistTID_2"]), $(f["Job_1"]), $(f["ArtistTID_1"]), $(f["releasenoteslines"]), $(f["BarCode"]), $(f["MainArtistAddress"]) }' OFS='|' "$theline" | awk '(NR>1)')

# Label
if [ -f "$Path2album"/_album_info/CSVs/Labels.csv ]
then
echo "${green}---> Label found"
labellist=$(cat "$Path2album"/_album_info/CSVs/Labels.csv |awk '(NR>1)')
cat "$Path2album"/_album_info/CSVs/Labels.csv

Label1=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 2'|awk -F'|' '{print $3}')
LabeCatalogNumber1=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 2'|awk -F'|' '{print $4}')

Label2=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 3'|awk -F'|' '{print $3}')
LabeCatalogNumber2=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 3'|awk -F'|' '{print $4}')

Label3=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 4'|awk -F'|' '{print $3}')
LabeCatalogNumber3=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 4'|awk -F'|' '{print $4}')
echo Label3 $Label3 $LabeCatalogNumber3 LabeCatalogNumber3 Label2 $Label2 $Label1 Label1 $LabeCatalogNumber1 LabeCatalogNumber1

fi

if [ -f "$Path2album"/_album_info/CSVs/YearMaster.csv ]
then
YearMaster=$(cat "$Path2album"/_album_info/CSVs/YearMaster.csv| awk  'NR == 2')
fi

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
TypeRelesae=$(echo "$lineFrmat" |awk -F'</a>, ' '{print $2}'|sed 's/<!-- -->//g' | awk -F'<' '{print $1}'| sed 's/, /@/g'|sed 's/.$//')

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


fi
SupportTypeRelease=$(cat "$Path2album"/_album_info/CSVs/info_support.csv| awk  'NR == 2')
#

echo "${white}---> Looking for artist at this point"
if [ -f  "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv ]
then
echo "${white}---> Artist info found                           : "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv"
else
echo "${red}---> The is no artist in                           : "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv"
if [ -f "$Path2album"/_album_info/ALBUM_Page.html ]
then
#cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' |tr -d '\r'| awk -F'<h1 ' '{print $2}'| awk -F'</h1>' '{print $1}'|sed 's/<span class="link_15cpV">/\
#/g' | awk '/\/artist\//'


Artisttmpp=$(cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' |tr -d '\r'| awk -F'<h1 ' '{print $2}'| awk -F'</h1>' '{print $1}'|sed 's/<span class="link_15cpV">/\
/g' | awk '/\/artist\//')


if [ -f tmp/Main_Artist_AlbumTMP ]
then
rm tmp/Main_Artist_AlbumTMP
fi
if [ -f tmp/artist_album_separator ]
then
rm tmp/artist_album_separator
fi

IFS=$'\n'
set -f
for artist_line in $(echo "$Artisttmpp")
do
#echo "$artist_line"
MainArtistName=$(echo "$artist_line"| awk -F'/artist/' '{print $2}' | awk -F'>' '{print $2}'| awk -F'</a' '{print $1}')
separator="<!-- -->"
if [[ "$artist_line" == *"$separator"* ]]
then
echo "${white}---> h1 line contains                              : ${orange}<!-- -->"
SeparatorPostSpan=$(echo "$artist_line"| awk -F'/artist/' '{print $2}' | awk -F'<!-- -->' '{print $2}'|awk -F'<' '{print $1}'| xargs)
else
echo "${white}---> h1 line doesn't contains                      : ${orange}<!-- -->
${white}---> using span method"
SeparatorPostSpan=$(echo "$artist_line"| awk -F'/artist/' '{print $2}' | awk -F'</a></span>' '{print $2}'|tr -d '\r'|sed 's/<span/\
<span/g'|sed 's/<\/span/\
<\/span/g'| awk '!/<\/span/'|awk NF|sed 's/<span>//g'| xargs)
fi

MainArtistUrl=$(echo "$artist_line"| awk -F'<a href="' '{print $2}' | awk -F'"' '{print $1}')
MainArtistTID=$(echo "$artist_line"| awk -F'/artist/' '{print $2}' | awk -F'-' '{print $1}')
MainArtistID=$(echo "$artist_line"| awk -F'/artist/' '{print $2}' | awk -F'"' '{print $1}')
#echo "$artist_line"  >> tmp/artist_album_separator


# Artist-address|ArtistID|Artist_TID|Artist
echo "$MainArtistUrl|$MainArtistID|$MainArtistTID|$MainArtistName|$SeparatorPostSpan" | sed 's/\ –\ <\!-- -->//g'>> tmp/Main_Artist_AlbumTMP
done

echo "Artist-address|ArtistID|Artist_TID|Artist|sufix-title" > "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv
cat tmp/Main_Artist_AlbumTMP | sed "s/&amp;/\&/g" | sed "s/&#39;/'/g" | sed 's/&#34;/"/g' >> "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv
fi

fi
Album_Title_temp=$( tail -n 1 "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv |awk -F'|' '{print $5}')
echo "${green}---> \$Album_Title                                : $Album_Title"
Artist_TID=$(cat "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv |awk 'NR == 2'|awk -F'|' '{print $3}'|awk NF)
echo "${green}---> \$Artist_TID                                 : $Artist_TID"
sufix_artist_group=$(cat "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv |sed '$ d'|awk 'NR == 2'|awk -F'|' '{print $5}'|awk NF)
echo "${green}---> \$sufix_artist_group                         : $sufix_artist_group"
ALBUMARTIST=$(cat "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv |awk 'NR == 3'|awk -F'|' '{print $3}'|awk NF)
echo "${green}---> \$ALBUMARTIST                                : $ALBUMARTIST"

if [ "$Artist" == "" ]
then
Artist=$(cat "$Path2album"/_album_info/_info_Artist/Main_Artist_Album.csv |awk 'NR == 2'|awk -F'|' '{print $4}'|awk NF)
fi


echo "$begining|$ALBUMARTIST|$Segment1|$Label1|$LabeCatalogNumber1|$Label2|$LabeCatalogNumber2|$Label3|$LabeCatalogNumber3|$Segment2|$YearMaster|$SupportTypeRelease|$sufix_artist_group" >> tmp/temp_update_lines
done

echo "DiscNumber|traxNumber|Artist|Album_Title|CoverFID|TrackTitle|ALBUMARTIST|DISCTOTAL|TRACKTOTAL|Duration|Audio|Label1|LabeCatalogNumber1|Label2|LabeCatalogNumber2|Label3|LabeCatalogNumber3|YEAR|Date|fileNoExt|Path2album|extension|FileSize|Genre|AlbumADDRESS|Album_TID|TheFileSoundID_fid|ID_DISCOGS|ImagesFID|NodeID|UUID|Artist_TID|Album_TID|AlbumURL|extension|TrackURL|FileOutNoExt|ISRC|compilation|compilationUUID|1_pers|1_info|2_pers|2_info|3_pers|3_info|4_pers|4_info|5_pers|5_info|6_pers|6_info|7_pers|7_info|8_pers|8_info|9_pers|9_info|10_pers|10_info|Job_10|ArtistTID_10|Job_9|ArtistTID_9|Job_8|ArtistTID_8|Job_7|ArtistTID_7|Job_6|ArtistTID_6|Job_5|ArtistTID_5|Job_4|ArtistTID_4|Job_3|ArtistTID_3|Job_2|ArtistTID_2|Job_1|ArtistTID_1|releasenoteslines|BarCode|MainArtistAddress|YearMaster|Support_Type|ReleaseType|sufix_artist_group" > tmp.csv

cat tmp/temp_update_lines >> tmp.csv





#|awk -F'|' '{print NF; exit}'
