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
echo "$bg_blue$white Hello I am More_info.sh$reset"
source tmp/tmp_Bash
echo "${white}---> Album Title : ${orange}$Album_Title"
echo "${white}---> The disk number is $DiscNumber ${white}the track number is ${orange}$tractNumber"

parentdir="$(dirname "$dir")"
if [ -f diskinfo/ALBUMNAME ]
then
albuminfo=$(cat diskinfo/ALBUMNAME)
fi
if [ "$Album_Title" == "$albuminfo" ]
then
echo "${white}---> ${green} Same album found keeping ${orange}diskinfo directory"
else
if [ -d diskinfo ]
then
rm -R diskinfo
fi


mkdir -p diskinfo
echo  "$Album_Title" > diskinfo/ALBUMNAME
#
## Information from discord
#



cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' |awk -F'class="body_' '{print $2}' |awk -F'class="main_2FbVC"' '{print $1}' | sed 's/<th/\
<th/g' | awk '/<th/' |awk -F'="row">' '{print $2}'> diskinfo/temp.html

cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' |awk -F'<h3>Tracklist</h3>' '{print $2}'|awk -F'</section>' '{print $1}'| sed 's/<tr/\
<tr/g' | awk '/<tr/' > diskinfo/temp2.html
fi

if [ -f diskinfo/test.csv ]
then
rm diskinfo/test.csv
fi
if [ -f diskinfo/1_info.csv ]
then
rm  diskinfo/*_info.csv
fi

#
## TRACKLIST
#
#Track Title on discogs
# Artist of the trak
IFS=$'\n'       # Processing line
set -f          # disable globbing

for TheLineInfoOnTrack in $(cat diskinfo/temp2.html)
do
#|awk -F'<td class="artist' '{print $2}'|awk -F'>' '{print $2}'
TrackLine=$(echo "$TheLineInfoOnTrack" |awk -F'</tr>' '{print $1}' |sed 's/<tr/\
<tr/g')
TrackTitleDSC=$(echo "$TrackLine" | awk -F'<td class="trackTitle_CTKp4"><span class="trackTitle_CTKp4">' '{print $2}'| sed "s/\&#x27;/'/g"| sed 's/\&quot;/"/g'| awk -F'<' '{print $1}')

#echo  |awk NF >> A.txt
credits=$(echo "$TrackLine" | awk -F'<div class="credits_12-wp expanded_3odiy">' '{print $2}' | awk -F'aria-hidden="true">' '{print $1}' |sed 's/<\/span>,/\
<\/span>,/g'|sed 's/<\/span> – <span/\
/g'|sed 's/<div><span>/\
/g'|awk NF |awk '{print $0}')
track_title="$TrackTitle"
TrackPostition=$(echo "$TrackLine" |awk -F'data-track-position="' '{print $2}'|awk -F'"' '{print $1}' |sed 's/<tr/\
<tr/g')
echo "$white$credits"
IFS=$'\n'       # Processing line
set -f          # disable globbing
echo "$purple$credits"
for cdreditInfo in $(echo "$credits")
do
#echo "$white$TrackTitleDSC"

artistAdress=$(echo $cdreditInfo|sed 's/<a href="\/artist/\
\/artist/g' | awk -F'"' '{print $1}'|awk 1 ORS=' ' |sed 's/  class= /|/g')
echo "$artistAdress aaa"
#echo $red $artistAdress

done

#echo "$blue$credits" |awk 1 ORS=' ' |sed 's/  class= /|/g'
done

if [ -f diskinfo/artist_listTMP ]
then
rm diskinfo/artist_listTMP
fi

#cat test.txt |sed 's/\[31m//g' |awk NF >> Tract.txt
if [ -f diskinfo/test.csv ]
then
matchtitle=$(awk -F'|' -v "track_title"="$track_title" '$1=='track_title'' diskinfo/test.csv)
echo $green matchtitle $matchtitle
Nmbrofresult=$(echo "$matchtitle"|wc -l)
# S'il y a plusieurs chansons du même nom dans l'album
if [ "$Nmbrofresult" -ge "2" ]
then
echo "$matchtitle"|sed 's/\/artist\//\
\/artist\//g'|sed 's/jobintrack-/\
/g' |sed '1d'> diskinfo/artist_listTMP
echo "Artist-address|ArtistID|Artist_TID|Artist" > diskinfo/artist_list.csv
cat diskinfo/artist_listTMP |sed '1d'|awk -F'|' '$2!=""' OFS='\t|\t' |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' >> diskinfo/artist_list.csv
if [ -f diskinfo/artist_list_Menu ]
then
rm diskinfo/artist_list_Menu
fi
cat diskinfo/artist_list.csv |sed '1d'|awk -F'|' '{print $2, $4, $5}' OFS='|'>> diskinfo/artist_list_Menu
echo "${white}---> Current track is Disk $DiscNumber ${white} track ${orange}$tractNumber"
echo "${bg_red}${white}---> There are mutiple result for this track with the name ${orange}$track_title ${white}<---${reset}"

# ### Menu de séléction Song
# ### Menu de séléction début
ResultatsMultiples=$(cat diskinfo/artist_list_Menu | awk -F'|'  '{print $3, $1, $2 }' OFS='\t|\t' )
#cp tmp/search_results_Album tmp/search_results_Album0111

echo " Track position |         Artist ID           |Artist Name"
SELECTION=1
while read -pru line
do
echo "${orange}########################################################################################################################################################
$SELECTION) $line${reset}"
((SELECTION++))
done <<< "$ResultatsMultiples"
((SELECTION--))
echo "${bg_blue}${white}########################################################################################################################################################
#    Il y a ${Nmbrofresult} résultats numéroté de 1 à ${Nmbrofresult} - Choisir parmis ces choix - puis enter
########################################################################################################################################################${reset}"
read -p "Selection :" opt
if [[ `seq 1 $SELECTION` =~ $opt ]]; then
echo $red$opt
fi



echo "$matchtitle"|sed 's/\/artist\//\
\/artist\//g'|sed 's/jobintrack-/\
/g' |sed '1d'> diskinfo/artist_listTMP
echo "Artist-address|ArtistID|Artist_TID|Artist" > diskinfo/artist_list.csv
cat diskinfo/artist_listTMP |sed '1d'|awk -F'|' '$2!=""' |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' >> diskinfo/artist_list.csv

cat diskinfo/artist_listTMP









else
echo "$matchtitle"|sed 's/\/artist\//\
\/artist\//g'|sed 's/jobintrack-/\
/g' |sed '1d'> diskinfo/artist_listTMP
echo "Artist-address|ArtistID|Artist_TID|Artist" > diskinfo/artist_list.csv
cat diskinfo/artist_listTMP |sed '1d'|awk -F'|' '$2!=""' |sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g' >> diskinfo/artist_list.csv
fi


function songinfo() {
count=00
for information in $(cat diskinfo/artist_listTMP)
do
jobbyjob=$(echo "$information"|awk -F'|' '$2==""'| awk -F'|' '{print $1}')
for job in $(echo "$jobbyjob")
do
count=$(( count+1 ))
echo "toberemoved"$count"_pers|"$count"_info tobejobremovedbefore"$job"tobejobremovedafter"
#echo
done
ArtistTID=$(echo "$information" |awk '/\/artist\//'| awk -F'|' '{print $3}')
echo $ArtistTID
done
}
#songinfo |awk NF sed |tr '\n' '@'
if [ -f diskinfo/tmpjob ]
then
rm diskinfo/tmpjob
fi
for i in $(songinfo); do echo -n $i'@'; done >> diskinfo/tmpjob; echo ''
cat diskinfo/tmpjob | sed 's/@tobejobremovedbefore/\
/g'| sed 's/tobejobremovedafter@/|/g' | sed 's/@toberemoved/\
/g'| sed 's/toberemoved//g' | sed 's/info tobejobremovedbefore/info|/g'|sed '$ s/@$//' > diskinfo/tmpjob2

for jobsline in $(cat diskinfo/tmpjob2)
do
#echo "$purple $jobsline"
InfoNumber=$(echo "$jobsline" |awk -F'|' '{print $2}')
numberseul=$(echo "$jobsline" |awk -F'|' '{print $2}'|awk -F'_' '{print $1}')
KindOfJob=$(echo "$jobsline" |awk -F'|' '{print $3}'|sed 's/\&#x27;/"/g'|sed 's/\&amp;/n/g'|sed 's/\&quot;/"/g')
JobPeople=$(echo "$jobsline" |awk -F'|' '{print $4}')
echo ""$numberseul"_pers|"$InfoNumber"
"$JobPeople"|"$KindOfJob"" > diskinfo/"$InfoNumber".csv
echo "$red$KindOfJob|$white$JobPeople"
echo $purple DEBUG END LOOP
done
echo $purple DEBUG OUT LOOP
fi

if [ -f diskinfo/1_info.csv ]
then
echo "1_info found"
else
echo "1_pers|1_info
|" > diskinfo/1_info.csv
fi


if [ -f diskinfo/2_info.csv ]
then
echo "2_info found"
else
echo "2_pers|2_info
|" > diskinfo/2_info.csv
fi
if [ -f diskinfo/3_info.csv ]
then
echo "3_info found"
else
echo "3_pers|3_info
|" > diskinfo/3_info.csv
fi

if [ -f diskinfo/4_info.csv ]
then
echo "4_info found"
else
echo "4_pers|4_info
|" > diskinfo/4_info.csv
fi

if [ -f diskinfo/5_info.csv ]
then
echo "5_info found"
else
echo "5_pers|5_info
|" > diskinfo/5_info.csv
fi


if [ -f diskinfo/6_info.csv ]
then
echo "6_info found"
else
echo "6_pers|6_info
|" > diskinfo/6_info.csv
fi

if [ -f diskinfo/7_info.csv ]
then
echo "7_info found"
else
echo "7_pers|7_info
|" > diskinfo/7_info.csv
fi

if [ -f diskinfo/8_info.csv ]
then
echo "8_info found"
else
echo "8_pers|8_info
|" > diskinfo/8_info.csv
fi




if [ -f diskinfo/9_info.csv ]
then
echo "9_info found"
else
echo "9_pers|9_info
|" > diskinfo/9_info.csv
fi

if [ -f diskinfo/10_info.csv ]
then
echo "10_info found"
else
echo "10_pers|10_info
|" > diskinfo/10_info.csv
fi

paste -d '|' diskinfo/1_info.csv diskinfo/2_info.csv diskinfo/3_info.csv diskinfo/4_info.csv diskinfo/5_info.csv diskinfo/6_info.csv diskinfo/7_info.csv diskinfo/8_info.csv diskinfo/9_info.csv diskinfo/10_info.csv > diskinfo/Trackinfo.csv
mv diskinfo/Trackinfo.csv tmp/Trackinfo.csv

echo $puple before tmp/Trackinfo.csv
cat tmp/Trackinfo.csv
IFS=$'\n'       # Processing line
set -f          # disable globbing
for thelinerow in $(cat diskinfo/temp.html)
do
# Label
LabelExport=$(echo "$thelinerow" |awk -F'</th><td>' '{print $2}' |awk '/label/' | sed 's/\/label\//\
\/label\//g')
echo $purple "$LabelExport"
IFS=$'\n'       # Processing line
set -f          # disable globbing
for lineslabel in $(echo "$LabelExport")
do
LabelGUID=$(echo "$lineslabel" |awk -F'"' '{print "genre"$1}'|tr '/' '-'|tr ' ' '-'|sed 's/\&amp;/n/g')
HRefLabel=$(echo "$lineslabel" |awk -F'"' '{print $1}')
LabelInnerHTML=$(echo "$lineslabel" | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'|sed 's/\&amp;/\&/g')
labelNumber=$(echo "$lineslabel" | awk -F'</a> – ' '{print $2}' | awk -F'<' '{print $1}'|sed 's/\&amp;/\&/g')
echo "$LabelGUID|$HRefLabel|$LabelInnerHTML|$labelNumber" >> diskinfo/labeltmp
done
#Label2feeds=$(tmp/labeltmp)

# Style Genre
StylesExport=$(echo "$thelinerow" |awk -F'</th><td>' '{print $2}' |awk '/style/' | sed 's/\/style\//\
\/style\//g' )
IFS=$'\n'       # Processing line
set -f          # disable globbing
for linestyle in $(echo "$StylesExport")
do
GenreGUID=$(echo "$linestyle" |awk -F'"' '{print "genre"$1}'|tr '/' '-'|tr ' ' '-'|sed 's/\&amp;/n/g')
HRefStyle=$(echo "$linestyle" |awk -F'"' '{print $1}')
StyleInnerHTML=$(echo "$linestyle" | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'|sed 's/\&amp;/\&/g')

echo $red GenreGUID $GenreGUID HRefStyle $HRefStyle StyleInnerHTML $StyleInnerHTML
if [ "$HRefStyle" == "" ]
then
echo "${bg_red}${white}style is empty $reset"
HRefStyle=""
StyleInnerHTML=""
echo "||" >> diskinfo/styletmp
else
echo "$GenreGUID|$HRefStyle|$StyleInnerHTML" >> diskinfo/styletmp
fi
done
if [ "$StylesExport" == "" ]
then
echo "${bg_red}${white}style is empty $reset"
echo "||" >> diskinfo/styletmp
fi
#Stylehref=$(echo "$thelinerow" |awk -F'</th><td>' '{print $2}' |awk '/style/' | sed 's/\/style\//\
#\/style\//g' | awk -F'"' '{print $1}' | awk '!/<a href=/' |tr '\n' '@')

#StyleInnerHTLM=$(echo "$thelinerow" |awk -F'</th><td>' '{print $2}' |awk '/style/' | sed 's/\/style\//\
#\/style\//g' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'| awk '!/<a href=/' |sed 's/\&amp;/\&/g')
#
#
#echo $green "$StyleInnerHTLM"
#echo ${purple}"$Stylehref"
echo "${white}---> \$Stylehref        "$Stylehref""
suite=$(echo "$thelinerow"|awk -F'<td>' '{print $2}')
FormatCSV=$(echo "$thelinerow"|awk '/Format</' |awk -F'<td>' '{print $2}'| awk -F'-->' '{print $2}'| awk -F'</' '{print $1}' |awk NF)
Released=$(echo "$thelinerow"|awk '/Released</' |awk -F'<time dateTime="2011">' '{print $2}'| awk -F'</' '{print $1}' |awk NF)
Label=$(echo "$thelinerow"|awk '/Label</' |awk -F'<time dateTime="2011">' '{print $2}'| awk -F'</' '{print $1}' |awk NF)

echo $red$FormatCSV
echo $green$suite
echo $blue$Released
echo $purple$RowType


done
if [ -f diskinfo/styletmp ]
then
echo "GenreGUID|GenreHref|Genre" > diskinfo/style.csv
cat diskinfo/styletmp  | awk '!/<a href=/' |awk NF >> diskinfo/style.csv
rm diskinfo/styletmp
fi

echo "LabelGUID|HRefLabel|LabelInnerHTML|labelNumber" > diskinfo/label.csv
cat diskinfo/labeltmp | awk '!/<a href=/'|awk NF >> diskinfo/label.csv
echo $purple "$Path2album"/_album_info/             "$Path2album"/_album_info/

if [ -f "$Path2album"/_album_info/artist_list.csv ]
then
cat "$Path2album"/_album_info/artist_list.csv  |sed '1d' > tmp/artist_listtmp.csv
fi

cat diskinfo/artist_list.csv |sed '1d' |awk '!seen[$0]++' |awk NF >> tmp/artist_listtmp.csv
echo "Artist-address|ArtistID|Artist_TID|Artist" > "$Path2album"/_album_info/artist_list.csv
cat tmp/artist_listtmp.csv |awk '!seen[$0]++' | awk NF >> "$Path2album"/_album_info/artist_list.csv

