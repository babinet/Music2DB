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



mkdir -p ../_Output ../_Processed tmp/_album_info/img tmp/_info_Artist/img

echo "${white}---> Looking for sub directories in ../_Source"
find ../_Source -type d | awk '!/_album_info/'| awk '!/_info_Artist/'|sed   's/\/\//\//g' > Subdirectories.list

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
for subdirectories in $(cat Subdirectories.list)
do
echo "${white}---> Processing directory                     : ${orange}$subdirectories"
find "$subdirectories"/ -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif"   | sed 's/\/\//\//g' > tmp/listtmp.txt

IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for thefilelist in $(cat tmp/listtmp.txt)
do
Path2currentDir=$(echo "$thefilelist" | sed 's|\(.*\)/.*|\1|' )
Path2ParentDirNOSOURCE=$(echo "$Path2currentDir" | sed 's|\(.*\)/.*|\1|' | sed 's/..\/_Source//g')
PathWithNoSourceFolder=$(echo "$Path2currentDir"| sed 's/..\/_Source//g')

echo "${white}---> \$Path2currentDir                         : ${orange}$Path2currentDir"
echo "${white}---> \$PathWithNoSourceFolder                  : ${orange}$PathWithNoSourceFolder"
echo "${white}---> \$Path2currentDir                         : ${orange}$Path2currentDir"
echo "${white}---> Processing file                           : ${orange}$thefilelist"
echo "${white}---> \$Path2ParentDir                          : ${orange}$Path2ParentDirNOSOURCE"
echo "${white}---> Processing file                           : ${orange}$thefilelist"

echo "$Path2currentDir" > tmp/curentdirectory.txt
done
# Move Direcory once processed
SubDirectoryProcessed=$(cat tmp/curentdirectory.txt)
if [ "$SubDirectoryProcessed" == "$subdirectories" ]
then
echo $purple Match found "$SubDirectoryProcessed" "$subdirectories
$Path2currentDir $PathWithNoSourceFolder"
mkdir -p ../_Processed/"$Path2ParentDirNOSOURCE"
mv "$subdirectories" ../_Processed/"$Path2ParentDirNOSOURCE"/
fi
done
if [ -f tmp/curentdirectory.txt ]
then
rm tmp/curentdirectory.txt
fi

#IFS=$'\n'       # make newlines the only separator
#set -f          # disable globbing
#for thefilelist in $(cat tmp/listtmp.txt)


cd -
