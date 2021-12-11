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
Album_TID=5464766



echo "${white}---> Liste des images et des IDs pour le .csv"
echo "${white}---> ID (fid) = Album_TID + le numéro de l'image"

IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
#if [ -f ]
for TheFileImagesTMP in $(cat tmp/imglist4couv.txt)
do
echo "$orange$TheFileImagesTMP"
#TheFileImagesTMP=$(cat tmp/imglist4couv.txt)
TheFileImages="${TheFileImagesTMP##*/}"
echo "${white}$TheFileImages"
ImageNumber=$(echo "$TheFileImages"|awk -F'_' '{print $2}'|awk -F'.' '{print $1}')
TheFileID_fid=$(echo $Album_TID$ImageNumber)
ImageURI=$(echo "$TheFileImagesTMP"|sed 's/..\/_Source/private:\/\/Music\//g'|sed "s/'/\\\'/g"|sed 's/\/\//\//g')
echo "$red$ImageURI"
echo "$TheFileID_fid|$TheFileImages|$ImageURI" >> tmp/imagesfiletmp.csv
done

echo "${white}---> Adress du fichier son pour l'import PHP via :${orange} use Drupal\file\Entity\File;"
echo "${white}---> ID (fid) = 100 + Album_TID"

BaseSoundFile=$(cat tmp/SOUNDFILE_BASE.txt)
TheFileSound="${BaseSoundFile##*/}"
echo "${white}$TheFileSound"
TheFileSoundID_fid=$(echo 100"$Album_TID$ImageNumber")
SoundURI=$(echo "$BaseSoundFile"|sed 's/..\/_Source/private:\/\/Music\//g'|sed "s/'/\\\'/g"|sed 's/\/\//\//g')

# CSV SOUND FILE
echo "TheFileSoundID_fid|TheFileSound|SoundURI
$TheFileSoundID_fid|$TheFileSound|$SoundURI" > tmp/Soundfile.csv

# CSV IMAGES FILES
echo "TheFileID_fid|TheFileImages|ImageURI" > tmp/imagesfile.csv
cat tmp/imagesfiletmp.csv >> tmp/imagesfile.csv
rm tmp/imagesfiletmp.csv


