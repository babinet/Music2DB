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
# ASSEMBLE AUDIO NODE
find ../_Output/ -name *_NodeAudio.csv | sed 's/\/\//\//g' > tmp/all_node_Audio_list.csv
for audiolines in $(cat tmp/all_node_Audio_list.csv)
do
cat "$audiolines" | awk  'NR == 2' >> tmp/all_node_Audiotmp
done
echo "DiscNumber|tractNumber|Artist|Album_Title|TrackTitle|ALBUMARTIST|DISCTOTAL|TRACKTOTAL|Duration|Audio|LABEL|YEAR|Date|fileNoExt|Path2album|extension|FileSize|Genre|AlbumADDRESS|Album_TID|TheFileSoundID_fid|ID_DISCOGS|ImagesFID|NodeID|UUID|Artist_TID|Album_TID|AlbumURL|extension|TrackURL|FileOutNoExt|ISRC" > ../_Output/_AUDIO_IMPORT.csv
cat tmp/all_node_Audiotmp >> ../_Output/_AUDIO_IMPORT.csv
rm tmp/all_node_Audiotmp tmp/all_node_Audio_list.csv

# ASSEMBLE AUDIO PHP
find ../_Output/ -name *_Soundfile.csv | sed 's/\/\//\//g' > tmp/all_sound_file_PHP_list.csv

for soundinformation in $(cat tmp/all_sound_file_PHP_list.csv)
do
fidlinesound=$(cat "$soundinformation" | awk  'NR == 2' |awk -F'|' '{print $1}')
filenamelinesound=$(cat "$soundinformation" | awk  'NR == 2'|awk -F'|' '{print $2}'|sed "s/'/\\\'/g")
urilinesound=$(cat "$soundinformation" | awk  'NR == 2'|awk -F'|' '{print $3}'|sed "s/'/\\'/g"|sed 's/private:\//private:\/\//g')
echo "\$file = File::create(['uid' => 1,'uuid' => '"$fidlinesound"', 'filename' => '"$filenamelinesound"', 'uri' => '"$urilinesound"', 'status' => 1,]);\$file->save();" >> tmp/tmp_AUDIOFILE_IMPORT_PHP
done
echo "use Drupal\file\Entity\File;" > ../_Output/_AUDIOFILE_IMPORT.txt
cat tmp/tmp_AUDIOFILE_IMPORT_PHP >> ../_Output/_AUDIOFILE_IMPORT.txt

# ASSEMBLE IMAGES PHP
find ../_Output/ -name imagesfile.csv | sed 's/\/\//\//g' > tmp/all_image_files_PHP_list.csv
for imageinfomation in $(cat tmp/all_image_files_PHP_list.csv)
do
cat "$imageinfomation"| sed '1d' | while read lineimages
do
fidlineimage=$(echo "$lineimages" |awk -F'|' '{print $1}')
filenamelineimage=$(echo "$lineimages" |awk -F'|' '{print $2}'|sed "s/'/\\'/g")
urilineimage=$(echo "$lineimages" |awk -F'|' '{print $3}'|sed 's/private:\//private:\/\//g'|sed "s/'/\\\'/g")
echo "\$file = File::create(['uid' => 1,'uuid' => '"$fidlineimage"', 'filename' => '"$filenamelineimage"', 'uri' => '"$urilineimage"', 'status' => 1,]);\$file->save();" >> tmp/IMAGES_FILE_IMPORT_PHP
done
done
echo "use Drupal\file\Entity\File;" > ../_Output/_IMAGES_FILE_IMPORT.txt
cat tmp/IMAGES_FILE_IMPORT_PHP >> ../_Output/_IMAGES_FILE_IMPORT.txt
