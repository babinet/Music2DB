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
cd $dir
echo "${white}---> I AM Tracks_Number_from_Name.sh"
echo "${white}---> Rename the tract N* id3 tags frome file name"
echo "The File name must begin with the track nuumber e.G: 01_PRINCE-Poem.flac"
mkdir -p ../_TracksReNumber
read -p "Put your folder/files in _TracksReNumber/folder_With tracks
${orange}then Press Enter${white} :" enter
cd ../_TracksReNumber
for d in */
do
cd "$d"
if [ -d tmp ]
then
rm -R tmp
fi
    
mkdir -p tmp
find ./ -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif" | sed 's/\/\//\//g' > tmp/listTracks.txt
TheTracksFile=$(cat tmp/listTracks.txt)

echo "$TheTracksFile TheTracksFile"
#sed -i.bak $'s/\x0D//' "$TheTracksFile"
#tr -d '\n' < "$TheTracksFile" | sed 's/TRACK/\
#TRACK/g' |sed '1d' > tmp/Liste4Tag.csv
#read -p "enter the ${orange}Title${white} of the album                        :" Album_Title
##read -p "enter the ${orange}Date${white} of the album                        :" date
#read -p "enter the ${orange}Year${white} of the album                         :" year
#read -p "enter the ${orange}Discogs ID${white} of the album                   :" ID_DISCOGS
#read -p "enter the ${orange}Artist/performer${white} of the album             :" Artist
#read -p "enter the ${orange}Disc#${white} of the album                        :" DiscNumber
#read -p "enter the ${orange}DISC TOTAL${white} of the album                   :" DISCTOTAL
#read -p "enter the ${orange}Genre${white} of the album comma separated        :" GenreToFile
##read -p "enter the  ${orange}Front${white} covert image (drop image)         :" AlbumCover
#Album_TID=$(echo $ID_DISCOGS| awk -F'-' '{print $1}')
#Machinamename=$(echo $ID_DISCOGS |sed 's/^[^-]*-//g')
#MachineNameFolder=$(echo "$Machinamename"-"$Album_TID")
##https://www.discogs.com/release/8227974-Prince-Come-From-Original-Test-Press
##Prince – Come From Original Test Press
##https://www.discogs.com/release/14451731-Prince-1999
##ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic  -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt"."$extension"
#echo $MachineNameFolder MachineNameFolder
#echo GenreToFile $GenreToFile
IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for ListForTag in $(cat tmp/listTracks.txt)
do

TrackNumber2tag=$(echo "$ListForTag" | awk -F'./' '{print $2}'| awk '{print $1}')

tractNumber=$(echo "$TrackNumber2tag"| tr -d '_'| awk '{sub(/^0*/,"");}1')
echo $purple$tractNumber ${white}tractNumber
CurentTrack=$(find ./ -name "$TrackNumber2tag"_*""| sed 's/\/\//\//g')
echo $purple$CurentTrack ${white}CurentTrack
TrackTitle=$(echo "$ListForTag" | awk -F'TITLE "' '{print $2}'| awk -F'"    ' '{print $1}')
trackoutput=$(echo "$CurentTrack"|sed 's/.\///g'| awk '{print "tmp/"$0}')
echo $trackoutput trackoutput
echo "$purple$TrackTitle${white}"
extension="${ListForTag##*.}"
echo $extension extension
filenoext=$(echo "$ListForTag"|sed 's/.\///g'| sed "s/$extension//")
if [ "$extension" == m4a ]
then
echo "${white}---> $ListForTag ${orange}M4A RULE !"
ffmpeg -i "$ListForTag" -codec:v copy -codec:a libmp3lame -q:a 2 -metadata track="$tractNumber" tmp/"$filenoext".mp3

echo $purple M4A
elif [ "$extension" == ogg ]
then
echo $purple OGG
elif [ "$extension" == dsf ]
then
echo $purple DSF
else

ffmpeg -i "$ListForTag" -codec:v copy -codec:a libmp3lame -q:a 2 -metadata track="$tractNumber" tmp/"$filenoext"."$extension"
fi

#ffmpeg -i "$CurentTrack" -c copy -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" "$trackoutput"
echo "$CurentTrack" -c copy -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" "$trackoutput"
done
#mkdir -p "$dir"/Processed/
#rm tmp/listTracks.txt
#rm tmp/Liste4Tag.csv
#
#mv tmp/ "$dir"/Processed/"$MachineNameFolder"
done

cd $dir
#mv "$dir"/Processed/ ../_Processed/

