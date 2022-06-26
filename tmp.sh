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
echo "${white}---> I AM Cue_FFMPEG_extract.sh"
echo "${white}---> I am dealing with the ${orange}24 bit .flac${white} audio and ${orange}list.cue${white} file"

dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd $dir
parentdir="$(dirname "$dir")"

echo "${white}---> The Flac aufio File name must be in the path ${orange}: ../_Processed/Album_Folder/Album_Tracks.cue & Album_Tracks.flac"
mkdir -p ../_CUE_PROCESS ../_TRASH_TMP "$parentdir"/_Processed
read -p "Put your folder/files in ../_CUE_PROCESS - One .cue file by folder
${orange}then Press Enter${white} :" enter


for directory in "$parentdir"/_CUE_PROCESS/*/
do
cd "$directory"
echo "${white}---> Changing directory to        :${green}$directory"

if [ -d tmp ]
then
rm -R tmp
fi
echo "${white}---> generating Utf8 .cue file    :${green}cue_converted"

mkdir -p tmp

find ./ -name "*.cue" | sed 's/\/\//\//g'|awk "NR == 1" > tmp/CueFiletmp
TheCueFile=$(cat tmp/CueFiletmp)
filenoext=$(echo "$TheCueFile"|sed 's/.\///g'| sed "s/.cue//")
encoding=$(file -b --mime-encoding "$TheCueFile")
encoding2=$(file -b --mime-encoding "cue_converted")
iconv -s -f CP1250 -t UTF-8 "$TheCueFile" > cue_converted
    sed -i.bak $'s/\x0D//' cue_converted
echo $encoding $encoding2

cat cue_converted #| tr -d '\n'

if [ -f disk.info ]
then
echo "${white}---> disk.info ${green}Found !"
source disk.info
else
read -p "enter the ${orange}Title${white} of the album                        :" Album_Title
read -p "enter the ${orange}Year${white} of the album                         :" year
read -p "enter the ${orange}Discogs ID${white} of the album                   :" ID_DISCOGS
read -p "enter the ${orange}Artist/performer${white} of the album             :" Artist
read -p "enter the ${orange}Disc#${white} of the album                        :" DiscNumber
read -p "enter the ${orange}DISC TOTAL${white} of the album                   :" DISCTOTAL
read -p "enter the ${orange}Genre${white} of the album comma separated        :" GenreToFile
echo "Album_Title=\"$Album_Title\"
year=\"$year\"
ID_DISCOGS=\"$ID_DISCOGS\"
DiscNumber=\"$DiscNumber\"
DISCTOTAL=\"$DISCTOTAL\"
Artist=\"$Artist\"
GenreToFile=\"$GenreToFile\"" > disk.info
fi
Album_TID=$(echo $ID_DISCOGS| awk -F'-' '{print $1}')
Machinamename=$(echo $ID_DISCOGS |sed 's/^[^-]*-//g')
MachineNameFolder=$(echo "$Machinamename"-"$Album_TID")


echo $purple MachineNameFolder $MachineNameFolder Machinamename $Machinamename Album_TID $Album_TID








done

#cat "/Users/zeus/WORKSHOP/1/_CUE_PROCESS/Sheila E. - Sheila E. (1987)/cue_converted" | awk '/  TRACK/{p=1}p' | tr -d '\n' #| sed 's/  TRACK /\
#/g' |awk NF |awk '{key=$0; getline; print key ", " $0;}'



# ffmpeg -ss 00:00:00 -i Help\!.flac -c copy -t 00:02:23 output.mp3

