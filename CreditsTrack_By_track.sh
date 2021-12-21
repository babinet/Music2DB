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
echo "$bg_blue$white Hello I am Credits.sh$reset"
echo "${white}---> i'm getting tracks taginfomation on Discogs"

source tmp/tmp_Bash
if [ -f diskinfo/1_info.csv ]
then
rm  diskinfo/*_info.csv
fi

echo $green"$DISCOGSID"
parentdir="$(dirname "$dir")"
if [ -f diskinfo/diskinfoDISCOGSID ]
then
diskinfoDISCOGSID=$(cat diskinfo/diskinfoDISCOGSID)
fi
echo DISCOGSID $DISCOGSID
#echo "2" > tmp/default_choice
if [ -f tmp/default_choice ]
then
default_choice=$(cat tmp/default_choice)
echo "${green}---> tmp/default_choice id already checkecked         :$orange$default_choice"
else
echo "${green}########################################################################################################################################
---> ${white}The current processed release page is             :${orange}$AdressReleaseDiscogs${green}
########################################################################################################################################"
read -p "Choices
1 = File name               :
2 = Discogs name            :
3 = Discogs Tracks mapping  :" Choices
echo "$Choices" > tmp/default_choice
default_choice=$(cat tmp/default_choice)
fi

if [ "$DISCOGSID" == "$diskinfoDISCOGSID" ]
then
echo "${bg_green}${white}---> Diskinfo already processed ! <---${reset}"
else
if [ -d diskinfo ]
then
rm -R  diskinfo
fi




echo "${white}---> Processing tracks on diskinfo"
mkdir -p diskinfo
echo "$DISCOGSID" > diskinfo/diskinfoDISCOGSID

cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' |awk -F'class="body_' '{print $2}' |awk -F'class="main_2FbVC"' '{print $1}' | sed 's/<th/\
<th/g' | awk '/<th/' |awk -F'="row">' '{print $2}'> diskinfo/temp.html

cat "$Path2album"/_album_info/ALBUM_Page.html | tr -d '\n' |awk -F'<h3>Tracklist</h3>' '{print $2}'|awk -F'</section>' '{print $1}'| sed 's/<tr/\
<tr/g' | awk '/<tr/' > diskinfo/temp2.html




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
Track_positionTMP=$(echo "$TheLineInfoOnTrack" |awk -F'trackPos_2RCje">' '{print $2}'|awk -F'<' '{print $1}'|awk NF| sed 's/^0*//')
if [[ "$Track_positionTMP" == *-* ]]
then
disk=$(echo "$Track_positionTMP" | awk -F'-' '{print $1}'|sed 's/CD//g'| sed 's/^0*//')
track=$(echo "$Track_positionTMP" | awk -F'-' '{print $2}'|sed 's/CD//g'| sed 's/^0*//')
Track_position=$(echo "$disk"-"$track"|sed 's/CD//g'| sed 's/^0*//')
else
Track_position=$(echo "$TheLineInfoOnTrack" |awk -F'trackPos_2RCje">' '{print $2}'|awk -F'<' '{print $1}'|awk NF| sed 's/^0*//'|awk '{print "1-"$0}')
fi
echo "${orange}$Track_position Track_position"
echo "Track_position_ROWSEP" >>diskinfo/tempo.txt
echo "$Track_position" |awk NF >>diskinfo/tempo.txt
echo "$TrackTitle" |awk NF >>diskinfo/tempo.txt
IFS=$'\n'       # Processing line
set -f          # disable globbing
for toloop in $(echo "$ToloopAfter")
do
job=$(echo "$toloop"| awk -F'<div><span>' '{print $2}'|awk -F'<' '{print $1}'|awk NF|sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g')
artistAddress=$(echo "$toloop"| awk '/\artist\//' | awk -F'"' '{print $1}'|awk NF)
artistName=$(echo "$toloop"| awk '/\artist\//' |awk -F'link_15cpV">' '{print $2}'|awk -F'<' '{print $1}'|awk NF|sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'|awk '{print $0"NEWLINENEWLINE"}')
artistTID=$(echo "$toloop"| awk '/\artist\//' | awk -F'/artist/' '{print $2}'| awk -F'-' '{print $1}'|awk NF)
artistID=$(echo "$toloop"| awk '/\artist\//' | awk -F'/artist/' '{print $2}'| awk -F'"' '{print $1}'|awk NF)

# SED Clean ASCI to utf8
# sed "s/\&#x27;/'/g"| sed 's/\&amp;/\&/g'|sed 's/\&quot;/"/g'
if [ "$job" == "" ]
then
RS=""
else
RS="Job_ROW_SEPARATOR"
fi
echo "$TRS
$RS
$job
|$artistTID|$artistAddress|$artistID|$artistName" |awk NF | awk '!/\|\|/' >>diskinfo/tempo.txt
done
done

#Just close the files after writing not to overload the RAM:
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



ListInfoTracks=$(find diskinfo/SongInfo/ -name *_Song_info.txt| sed 's/\/\//\//g')
IFS=$'\n'       # Processing line
set -f          # disable globbing
for informations in $(echo "$ListInfoTracks")
do
cat "$informations" |awk '(NR>2)' | awk -F'|' '{print $3, $4, $2, $5}' OFS='|' >> tmp/artist_list_tracksTMP.csv
SongName=$(cat "$informations" |awk 'NR == 2')
TrackNumber=$(cat "$informations" |awk 'NR == 1'|sed 's/CD//g')
echo "$TrackNumber|$SongName">> diskinfo/songs_list.csv

done
echo "Artist-address|ArtistID|Artist_TID|Artist" > tmp/artist_list_tracks.csv
if [ -f tmp/artist_list_tracksTMP.csv ]
then
echo "${white}---> Found ${green}tmp/artist_list_tracksTMP.csv "
cat tmp/artist_list_tracksTMP.csv | awk '!/./ || !seen[$0]++' >> tmp/artist_list_tracks.csv
rm tmp/artist_list_tracksTMP.csv
else
echo "${red}---> NOT artist list FOUND !!! yet         :tmp/artist_list_tracksTMP.csv "
fi
source tmp/tmp_Bash


if [ "$default_choice" == 3 ]
then
echo "${white}---> Looking for trackinfo in"
echo "$purple---> The curent file is : ${white}DiscNumber ${orange}$DiscNumber ${white}traxNumber ${orange}$traxNumber ${white}Title ${orange}$TrackTitle"

find diskinfo/SongInfo/ -name *_Song_info.txt | sed 's/\/\//\//g' > tmp/temp_tracks_menu
IFS=$'\n'       # Processing line
set -f          # disable globbing

if [ -f tmp/track_menu_select ]
then
rm tmp/track_menu_select
fi
for tracks_titles in $(cat tmp/temp_tracks_menu)
do
trackpose=$(cat "$tracks_titles"| awk "NR == 1")
Title=$(cat "$tracks_titles"| awk "NR == 2")
echo "$trackpose    |$Title" >> tmp/track_menu_select
done


#!/bin/bash
prompt="N# |Trk pos |   Choose the N# of the corresponding track"
options=( $(cat tmp/track_menu_select) )

PS3="$prompt "
select chosen_track in "${options[@]}" "Quit" ; do
    if (( REPLY == 1 + ${#options[@]} )) ; then
        exit

    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        echo  "${orange}You chose "$chosen_track"_Song_info.txt $REPLY"
        break

    else
        echo "Invalid option. Try another one."
    fi
done
track_choice=$(echo "$chosen_track"| awk '{print $1}')
TrackTitle=$(echo "$chosen_track"| awk -F'|' '{print $2}')
cat diskinfo/SongInfo/"$track_choice"_Song_info.txt
echo "$TrackTitle" | sed 's/\$/USD/g' | sed "s/\&amp;/'/g"> diskinfo/TrackName
echo "TrackTitle=\$(cat diskinfo/TrackName)" >> tmp/tmp_Bash
TRACTITLE_ON_DOSCOGS="$TrackTitle"




else



TRACTITLE_ON_DOSCOGS=$(cat diskinfo/SongInfo/"$DiscNumber"-"$traxNumber"_Song_info.txt |awk 'NR == 2')

if [ "$default_choice" == 1 ]
then
echo "$TrackTitle" | sed 's/\$/USD/g'> diskinfo/TrackName
echo "TrackTitle=\$(cat diskinfo/TrackName)" >> tmp/tmp_Bash
elif [ "$default_choice" == 2 ]
then
echo "$TRACTITLE_ON_DOSCOGS" | sed 's/\$/USD/g'> diskinfo/TrackName
echo "TrackTitle=\$(cat diskinfo/TrackName)" >> tmp/tmp_Bash

else

if [ "$TRACTITLE_ON_DOSCOGS" == "$TrackTitle" ]
then
echo "${green}---> Track title match \$TrackTitle == \$TRACTITLE_ON_DOSCOGS"
else
echo "${bg_red}${white}---> Track title mismatch \$TRACTITLE_ON_DOSCOGS == \$TrackTitle <---${reset}"
echo "Source name|$TrackTitle
Discogs name|$TRACTITLE_ON_DOSCOGS
Manual Name |User invit" > diskinfo/trackChoice
# ### Menu de séléction Track name
MisMatch=$(cat diskinfo/trackChoice | awk -F'|'  '{print $1, $2 }' OFS='\t|\t' )
SELECTION=1
while read -pru line
do
echo "${white}########################################################################################################################################################
$SELECTION) $line${reset}"
((SELECTION++))
done <<< "$MisMatch"
((SELECTION--))
echo "${bg_blue}${white}########################################################################################################################################################
#${bg_red}${white}---> Source File Trac Name = ${orange}$TrackTitle${white} /// Discogs Track Name = ${orange}$TRACTITLE_ON_DOSCOGS${white}  ${orange}DiscNumber:${white}$DiscNumber ${orange}traxNumber:${white}$traxNumber <---${reset}
${white}########################################################################################################################################################${reset}"
read -p "Selection :" opt
#if [[ `seq 1 $SELECTION` =~ $opt ]]; then
#echo $red$opt
#break;
#fi
if [ $opt == "1" ]
then
echo 1 $TrackTitle
echo "$TrackTitle" | sed 's/\$/USD/g'> diskinfo/TrackName
echo "TrackTitle=\$(cat diskinfo/TrackName)"| sed "s/\&amp;/\&/g" >> tmp/tmp_Bash
elif [ $opt == "2" ]
then
echo 2 $TRACTITLE_ON_DOSCOGS
echo "$TRACTITLE_ON_DOSCOGS" | sed 's/\$/USD/g'> diskinfo/TrackName
echo "TrackTitle=\$(cat diskinfo/TrackName)"| sed "s/\&amp;/'/g" >> tmp/tmp_Bash
elif [ $opt == "3" ]
then
echo "${white}---> Manual edit"
read -p "Enter the track name : " READTRACKNAME
echo "$READTRACKNAME" | sed 's/\$/USD/g' | sed "s/\&amp;/'/g"> diskinfo/TrackName
echo "TrackTitle=\$(cat diskinfo/TrackName)" >> tmp/tmp_Bash
fi

fi  

fi





fi

if [ "$default_choice" == 3 ]
then
echo "${green}Jobs on tracks from manual select"
cat diskinfo/SongInfo/"$track_choice"_Song_info.txt | awk '(NR>2)' | awk -F'|' '{print $2, $1}' OFS='|' > diskinfo/SongInfo/"$DiskSongNumber"_taxo_track_info.txt
else
# Jobs on tracks
echo "${green}Jobs on tracks"
cat diskinfo/SongInfo/"$DiscNumber"-"$traxNumber"_Song_info.txt | awk '(NR>2)' | awk -F'|' '{print $2, $1}' OFS='|' > diskinfo/SongInfo/"$DiskSongNumber"_taxo_track_info.txt
fi
IFS=$'\n'       # Processing line
set -f          # disable globbing
index=0
for informations in $(cat diskinfo/SongInfo/"$DiskSongNumber"_taxo_track_info.txt)
do
index=$(( index+1 ))
echo ""$index"_pers|"$index"_info
$informations" > diskinfo/"$index"_info.csv
done


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
if [ -f diskinfo/artist_list.csv ]
then
cat diskinfo/artist_list.csv |sed '1d' |awk '!seen[$0]++' | awk NF >> tmp/artist_listtmp.csv
fi
if [ -f tmp/artist_listtmp.csv ]
then
echo "Artist-address|ArtistID|Artist_TID|Artist" > "$Path2album"/_album_info/artist_list.csv
cat tmp/artist_listtmp.csv |awk '!seen[$0]++' | awk NF >> "$Path2album"/_album_info/artist_list.csv
else
echo "${orange}---> There is no artist"
fi


