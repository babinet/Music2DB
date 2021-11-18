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
parentdir="$(dirname "$dir")"
echo "${white}---> I AM Tracks_Number_from_Name.sh"
echo "${white}---> Rename the tract N* id3 tags frome file name"
echo "The File name must begin with the track nuumber e.G: 01_PRINCE-Poem.flac"
mkdir -p ../_CUE_PROCESS
read -p "Put your folder/files in _CUE_PROCESS/folder_With tracks
${orange}then Press Enter${white} :" enter

for directory in "$parentdir"/_CUE_PROCESS/*/
do
cd "$directory"
presentdirectory=$(pwd)
echo "${white}---> Change directory             : ${orange}$presentdirectory"
if [ -d tmp ]
then
rm -R tmp
fi


#


mkdir -p tmp
find ./ -name "*.cue" | sed 's/\/\//\//g'|awk "NR == 1" > tmp/CueFiletmp
TheCueFile=$(cat tmp/CueFiletmp)
filenoext=$(echo "$TheCueFile"|sed 's/.\///g'| sed "s/.cue//")
echo $filenoext filenoextfilenoextfilenoextfilenoextfilenoextfilenoextfilenoext
ffprobe "$filenoext".flac > tmp/temp_info.txt 2>&1
AudioInfo=$(cat tmp/temp_info.txt|awk '/Stream #0:0: Audio/')
if [[ $AudioInfo == *"24 bit"* ]]; then
echo "${bg_red}${white}---> Audio 24 bit <---${reset}"
echo "${white}---> Converting 24 bit audio to 16 bit audio ${reset}"
#ffmpeg -i "$filenoext".flac -sample_fmt s16 -ar 44100 tmp/output.flac
sox "$filenoext".flac -b 16 -r 44.1k tmp/output.flac
mv "$filenoext".flac "$filenoext".flac_BACK
mv tmp/output.flac "$filenoext".flac
fi


find . -name "*.cue" -exec sh -c 'exec shnsplit -f "$1" -o flac -t "%n_%p-%t" "${1%.cue}.flac"' _ {} \;
echo "${wjite}---> $directory ${green}Done" ## note the quotes, those are essential
done

##cd ../_CUE_PROCESS
#for d in */
#do
#

#cd "$parentdir/$d"
#if [ -d tmp ]
#then
#rm -R tmp
#fi
#
#
#
#
#
#mkdir -p tmp
#
#find ./ -name "*.cue" | sed 's/\/\//\//g'|awk "NR == 1" > tmp/CueFiletmp
#TheCueFile=$(cat tmp/CueFiletmp)
#filenoext=$(echo "$TheCueFile"|sed 's/.\///g'| sed "s/.cue//")
#encoding=$(file -b --mime-encoding "$TheCueFile")
#ls -lah "$TheCueFile"
#if [ "$TheCueFile" == utf-8 ]
#then
#echo "${white}---> The file encoding is ${orange}utf-8"
#else
#echo "${white}---> The file encoding is ${orange}$encoding"
#fi
#
#
#
#
#
#find . -name "*.cue" -exec sh -c 'exec shnsplit -f "$1" -o flac -t "%n_%p-%t" "${1%.cue}.flac"' _ {} \;
#
#done




cd $dir
#mv "$dir"/Processed/ ../_Processed/

