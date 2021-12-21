#!/bin/bash
mkdir -p tmp
find . -name _Album_AUDIO_IMPORT.csv | sed 's/\.\///g'| sed 's/\/\//\//g' > tmp/AlbumCSVs_Lists.txt

IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
if [ -f tmp/Album_infoTMP.txt ]
then
rm tmp/Album_infoTMP.txt
fi
for AlbumInformation in $(cat tmp/AlbumCSVs_Lists.txt)
do

cat "$AlbumInformation" | sed '1d' >> tmp/Album_infoTMP.txt

done

headerLine=$(awk 'NR == 1' tmp/AlbumCSVs_Lists.txt)
Header=$(cat "$headerLine"| awk 'NR == 1')
echo "$Header" > _ALL_ALBUMS.csv
cat tmp/Album_infoTMP.txt >> _ALL_ALBUMS.csv



find . -name __IMPORT_ALL_PHP.txt | sed 's/\.\///g'| sed 's/\/\//\//g' > tmp/PHP_LIST_PHP.txt

IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
if [ -f tmp/AlbumPHPTMP.txt ]
then
rm tmp/AlbumPHPTMP.txt
fi
for AlbumInformationPHP in $(cat tmp/PHP_LIST_PHP.txt)
do

cat "$AlbumInformationPHP" | sed '1d' >> tmp/AlbumPHPTMP.txt

done

#headerLinePHP=$(awk 'NR == 1' tmp/PHP_LIST_PHP.txt)
#HeaderPHP=$(cat "$headerLinePHP"| awk 'NR == 1')
echo "use Drupal\file\Entity\File;" > _ALL_ALBUMS_PHP.txt
cat tmp/AlbumPHPTMP.txt >> _ALL_ALBUMS_PHP.txt
