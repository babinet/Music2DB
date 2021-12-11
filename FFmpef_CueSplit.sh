




#ffmpeg -ss 00:00:00 -i Help\!.flac -t 00:02:23 output.flac


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
parentdir="$(dirname "$dir")"
cd $dir
parentdir="$(dirname "$dir")"
echo "${white}---> I AM FFmpef_CueSplit.sh"
echo "${white}---> I Split .flac or .ape to tagged id3 files"
echo "${white}---> The .cue file must be like bellow:"
echo 'REM COMMENT "ExactAudioCopy v0.95b4"
PERFORMER "PRINCE"
TITLE "COME Original Test Pressing"
FILE "PRINCE - COME Original Test Pressing.flac" WAVE
  TRACK 01 AUDIO
    TITLE "Poem"
    PERFORMER "PRINCE"
    INDEX 01 00:00:00
  TRACK 02 AUDIO
    TITLE "Interactive"
    PERFORMER "PRINCE"
    INDEX 01 03:36:00
  TRACK 03 AUDIO
'
echo "The File name must begin with the track nuumber e.G: 01_PRINCE-Poem.flac"
mkdir -p ../_CUE_PROCESS ../_TRASH_TMP
read -p "Put your folder/files in _CUE_PROCESS - One .cue file by folde
${orange}then Press Enter${white} :" enter
mkdir -p "$parentdir"/_Processed
for directory in "$parentdir"/_CUE_PROCESS/*/
do
cd "$directory"
presentdirectory=$(pwd)
echo "${white}---> Change directory             : ${orange}$presentdirectory"
if [ -d tmp ]
then
rm -R tmp
fi

mkdir -p tmp
find ./ -name "*.cue" | sed 's/\/\//\//g'|awk "NR == 1" > tmp/CueFiletmp
TheCueFile=$(cat tmp/CueFiletmp)
filenoext=$(echo "$TheCueFile"|sed 's/.\///g'| sed "s/.cue//")
encoding=$(file -b --mime-encoding "$TheCueFile")
iconv -s -f CP1250 -t UTF-8 "$TheCueFile" > cue_converted
TheCueFile="cue_converted"
echo "${white}---> The file encoding is ${orange}$encoding"

sed -i.bak $'s/\x0D//' "$TheCueFile"
tr -d '\n' < "$TheCueFile" | sed 's/TRACK/\
TRACK/g' |sed '1d' > tmp/Liste4Tag.csv
if [ -f disk.info ]
then
echo "${white}---> disk.info ${green}Found !"
source disk.info
else
read -p "enter the ${orange}Title${white} of the album                        :" Album_Title
#read -p "enter the ${orange}Date${white} of the album                        :" date
read -p "enter the ${orange}Year${white} of the album                         :" year
read -p "enter the ${orange}Discogs ID${white} of the album                   :" ID_DISCOGS
read -p "enter the ${orange}Artist/performer${white} of the album             :" Artist
read -p "enter the ${orange}Disc#${white} of the album                        :" DiscNumber
read -p "enter the ${orange}DISC TOTAL${white} of the album                   :" DISCTOTAL
read -p "enter the ${orange}Genre${white} of the album comma separated        :" GenreToFile
#read -p "enter the  ${orange}Front${white} covert image (drop image)         :" AlbumCover
echo "Album_Title=$Album_Title
year=$year
ID_DISCOGS=$ID_DISCOGS
DiscNumber=$DiscNumber
DISCTOTAL=$DISCTOTAL
Artist=$Artist
GenreToFile=$GenreToFile" > disk.info
fi
Album_TID=$(echo $ID_DISCOGS| awk -F'-' '{print $1}')
Machinamename=$(echo $ID_DISCOGS |sed 's/^[^-]*-//g')
MachineNameFolder=$(echo "$Machinamename"-"$Album_TID")
#https://www.discogs.com/release/8227974-Prince-Come-From-Original-Test-Press
#Prince – Come From Original Test Press
#https://www.discogs.com/release/14451731-Prince-1999
#ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic  -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt"."$extension"
echo $MachineNameFolder MachineNameFolder
echo GenreToFile $GenreToFile
IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for ListForTag in $(cat tmp/Liste4Tag.csv)
do

TrackNumber2tag=$(echo "$ListForTag" | awk -F'TRACK ' '{print $2}'| awk '{print $1}')
tractNumber=$(echo "$TrackNumber2tag"| awk '{sub(/^0*/,"");}1')
echo $purple$tractNumber ${white}tractNumber
CurentTrack=$(find ./ -name "$TrackNumber2tag"_*""| sed 's/\/\//\//g')
echo $purple$CurentTrack ${white}CurentTrack
TrackTitle=$(echo "$ListForTag" | awk -F'TITLE "' '{print $2}'| awk -F'"    ' '{print $1}')
trackoutput=$(echo "$CurentTrack"|sed 's/.\///g'| awk '{print "tmp/"$0}')
echo $trackoutput trackoutput
echo "$purple$TrackTitle${white}"
ffmpeg -i "$CurentTrack" -c copy -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" "$trackoutput"
echo "$CurentTrack" -c copy -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" "$trackoutput"

done
FileDate=$(date +%Y_%m_%d_%Hh%Mm%Ss | tr "/" "_")
#mkdir -p "$dir"/Processed/
#rm tmp/CueFiletmp
#rm tmp/Liste4Tag.csv
if [ -d "$parentdir"/_Processed/"$MachineNameFolder"_"$DiscNumber" ]
then
mv "$parentdir"/_Processed/"$MachineNameFolder"_"$DiscNumber" "$parentdir"/_TRASH_TMP/"$FileDate"_"$MachineNameFolder"_"$DiscNumber"
fi

#mv tmp "$parentdir"/_Processed/"$MachineNameFolder"_"$DiscNumber"
#FileDate=$(echo $(date +%%Y_%%m_%%d_%%Hh%%Mm%%Ss) | tr "/" "_")

done



#FileDate=$(echo $(date +%%Y_%%m_%%d_%%Hh%%Mm%%Ss) | tr "/" "_")

#cd $dir
#mv "$dir"/Processed/ ../_Processed/

