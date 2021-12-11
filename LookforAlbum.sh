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
#if [ -d tmp ]
#then
#rm -R tmp
#fi
mkdir -p ../_Output tmp
#find ../_Flac -name *.flac > listflac.txt
#if [ -s listflac.txt ]
#then
#echo "---> File Flac is Full"
#IFS=''
#while read flaclist
#do
#echo "$white$flaclist"
#fileOut=$(echo "$flaclist" | sed 's/.flac/.mp3/g'| sed 's/..\/_Flac/..\/_Output/g'| sed "s/'/\\'/g")
#echo "$red a $fileOut a"
#OutFolder=$(echo "$flaclist" | sed 's/..\/_Flac/..\/_Output/g'|awk  'BEGIN{OFS=FS="/"};{$NF="";print $0}' | sed 's/\x27\x27/\x27bar\x27/')
#mkdir -p "$OutFolder"
#ffmpeg -i $flaclist -qscale:a 0 $fileOut
#
#done < listflac.txt
#
#else
#echo "$purple---> File Flac is Empty"
#fi
count=10144
find ../_SOURCE -name *.mp3  > tmp/listtmp.txt

while read thefilelist
do
echo "$white---> Processing file ffprobe    : $orange$thefilelist"
ffprobe "$thefilelist" > tmp/temp_info.txt 2>&1






track_title=$(cat tmp/temp_info.txt | awk '/    title           :/'| awk -F'    title           : ' '{print $2}')
echo "$white---> Track title                : $orange$track_title"
artist=$(cat tmp/temp_info.txt | awk '/    artist          :/'| awk -F'    artist          : ' '{print $2}')
album=$(cat tmp/temp_info.txt | awk '/    album           :/'| awk -F'    album           : ' '{print $2}')
#cat tmp/temp_info.txt | awk '/    album           :/'| awk -F'    album           : ' '{print $2}' > tmp/album_name
#album=$(cat tmp/album_name)
echo "$white---> Album                      : $album"
field_track_n=$(cat tmp/temp_info.txt | awk '/    track           :/'| awk -F'    track           : ' '{print $2}'| awk -F"/" '{print $1}')
genre=$(cat tmp/temp_info.txt | awk '/    genre           :/'| awk -F'    genre           : ' '{print $2}' | sed 's/, /@/g')
track_title=$(cat tmp/temp_info.txt | awk '/    title           :/'| awk -F'    title           : ' '{print $2}')
TRACKTOTAL=$(cat tmp/temp_info.txt | awk '/    TRACKTOTAL      :/'| awk -F'    TRACKTOTAL      : ' '{print $2}')
isrc=$(cat tmp/temp_info.txt | awk '/    ISRC            :/'| awk -F'    ISRC            : ' '{print $2}')
field_cd=$(cat tmp/temp_info.txt | awk '/    disc            :/'| awk -F'    disc            : ' '{print $2}'| awk -F"/" '{print $1}')
date=$(cat tmp/temp_info.txt | awk '/    date            :/'| awk -F'    date            : ' '{print $2}')
label=$(cat tmp/temp_info.txt | awk '/    LABEL           :/'| awk -F'    LABEL           : ' '{print $2}')
Duration=$(cat tmp/temp_info.txt | awk '/  Duration: /'| awk -F'  Duration: ' '{print $2}'| awk -F', ' '{print $1}')
ArtistMachineName=$(echo "$artist" | tr ' ' '_')

echo "$white---> Album                      : ${orange}$album"


echo $purple$TRACKTOTAL
if [ "$TRACKTOTAL" == "" ]
then
echo "$white---> TRACKTOTAL                 : ${red}No TRACKTOTAL"
else
echo "$white---> TRACKTOTAL                 : ${orange}$TRACKTOTAL"
fi

#ArtistDiscorgs=$(echo "$artist"| tr ' ' '+')
#TrackDiscorgs
Path2album=$(echo "$thefilelist" | sed 's|\(.*\)/.*|\1|' )
echo "$white---> Path 2 File (Source)       : $orange$Path2album"
Path2artist=$(echo "$Path2album" | sed 's|\(.*\)/.*|\1|' )
echo "$white---> Path 2 artist (Source)     : $orange$Path2artist"



searchAlbummachinename=$( echo "https://www.discogs.com/search?q=$album" |sed "s/\]/%5B/g"|sed "s/\[/%5D/g" |sed "s/'/%27/g" |sed 's/&/%26/g' | sed 's/ /%20/g')
searchArtistmachinename=$( echo "$artist" |sed "s/\]/%5B/g"|sed "s/\[/%5D/g" |sed "s/'/%27/g" |sed 's/&/%26/g' | sed 's/ /%20/g')


#ID
# If exist
path2id=$(find "$Path2album" -name artistID.csv)
if [ -f "$path2id" ]
then
echo "$white---> File ID                    : ${green}Found !${white} $path2id"
ArtistID=$(cat "$path2id" | awk  'NR == 2' )


else
echo "$white---> File ID                    : ${orange}Not Found !"
echo "$white---> Searching artist           : ${orange}$artist ${white}discogs.com"
#curl -o tmp/SearchResultArtist -LO "https://www.discogs.com/fr/artist/"$searchArtistmachinename""

cat tmp/SearchResultArtist | awk '/"@id": "https:\/\/www.discogs.com\/fr\/artist/' | awk -F'https' '{print "https"$2}'| awk -F'"' '{print $1}' |awk '{print $1}' |awk 'NR == 1' > tmp/AddressArtist.txt
# Schema
#

# searchArtistmachinename
#https://www.discogs.com/search?q=Whole%20Lotta%20Love%204%20Paris&artist=prince
#https://www.discogs.com/search?q=Whole%20Lotta%20Love%204%20Paris&type=all
#https://www.discogs.com/search?q=Sign O' The Times (Super Deluxe)&artist=prince
AddressPageArtist=$(cat tmp/AddressArtist.txt)
echo "$white---> Address Page Artist        : $orange$AddressPageArtist"
#curl -o ootpout"$album".html -LO $searchAlbummachinename"&artist="$searchArtistmachinename


echo curl -o ootpout"$album".html -LO $searchAlbummachinename"&artist="$searchArtistmachinename




ArtistID=$(echo "$AddressPageArtist"| awk -F'/artist/' '{print $2}' )
curl -o tmp/"$ArtistID"_"$artist" -LO ""$AddressPageArtist"?limit=500&page=1"
#echo "$purple $searchAlbummachinename      $searchAlbummachinename&artist=$searchArtistmachinename"
cat 
#class="card card_large



fi


Artist_TID=$(echo "$ArtistID"| awk -F'-' '{print "10000"$1}' )
echo "$white---> Artist ID discogs.com      : $orange$ArtistID"
echo "$white---> Artist TID                 : $orange$Artist_TID"




echo "$white---> Crating artist folder (dest): ${orange}../_Output/"$ArtistMachineName"/_info_"$artist"_Info"
mkdir -p "../_Output/"$ArtistID"/_info_"$ArtistMachineName"_Info"

echo "ArtistID
$ArtistID" > tmp/artistID.csv
echo "Artist_TID
$Artist_TID" > tmp/artist_TID.csv
mkdir -p "$Path2album"/_info_Album/
cp tmp/*.csv "../_Output/"$ArtistID"/_info_"$ArtistMachineName"_Info/"
cp tmp/*.csv "$Path2album"/_info_Album/






cp tmp/"$ArtistID"_"$artist" ../_Output/"$ArtistID"/_info_"$ArtistMachineName"_Info/__"$artist"_Info
AlbumDiscorgs=$(cat ../_Output/"$ArtistID"/__"$ArtistMachineName"_Info/"$ArtistID"_"$artist"| awk -v "album"="$album" '/>"album"</')
cat ../_Output/"$ArtistID"/__"$ArtistMachineName"_Info/"$ArtistID"_"$artist"| awk -v "album"="$album" '/>"album"</'
echo $purple$AlbumDiscorgs AlbumDiscorgs
#artistResult=$(cat tmp/SearchResultArtist| tr -d '\n'| sed 's/data-object-type\=\"artist\"/\
#data-object-type="artist"/g' | awk '/data-object-type="artist"/'| awk -v "artist"="$artist" '/\>'$artist'\</'|awk NF)
echo "$artistResult" > tmp/artistResult
count=$(( count+1 ))
echo $purple"$count"
field_soundTMP=$(cat tmp/temp_info.txt|awk '/ from '\''..\/_SOURCE\//')
echo $field_soundTMP field_soundTMP
field_sound=$(echo ${field_soundTMP##*/}| sed "s/'://g")
nid=$(echo $count)






echo $nid

#echo "$white$album"
#echo "$orange$artist"
#echo "$purple$track_title"
#echo "$white$field_track_n"
#echo "$red$isrc"
#echo "$white$Duration"
#echo "$blue$TRACKTOTAL"
#echo "$blue$genre"
#echo "$blue$label"
#echo "$blue$field_cd"
#echo "$white$Duration"
#echo "$field_sound"
echo "$nid|$artist|$album|$track_title|$field_cd|$field_track_n|$isrc|$Duration|$TRACKTOTAL|$genre|$label|$Duration|$field_sound|" >> temp_import

done < tmp/listtmp.txt
echo "nid|field_artist|field_album|track_title|field_cd|field_track_n|isrc|Duration|TRACKTOTAL|genre|label|Duration|field_sound|field_aut_inter" > ../IMPORT.csv
cat temp_import >> ../IMPORT.csv
rm temp_import
#| sed 's/..\/_SOURCE\//_SOURCE\//g' |awk '{print "\""$0"\""}'

#   number=$(echo $line | cut -d " " -f 1)

# |tr -d '\n'
