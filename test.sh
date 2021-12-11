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
if [ -d tmp ]
then
rm -R tmp
fi

mkdir -p tmp
#echo "${white}---> Looking for sub directories in ../_Source"
#find ../_Source -type d | awk '!/_album_info/'| awk '!/_info_Artist/'|sed   's/\/\//\//g' > Subdirectories.list

#IFS=$'\n'       # make newlines the only separator
#set -f          # disable globbing
#for subdirectories in $(cat Subdirectories.list)
#do
echo "${white}---> Processing directory                     : ${orange}$subdirectories"
find "../_Source" -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif"   | sed 's/\/\//\//g' > tmp/listtmp.txt

IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for thefilelist in $(cat tmp/listtmp.txt)
do
extension="${thefilelist##*.}"

#Path2currentDir=$(echo "$thefilelist" | sed 's|\(.*\)/.*|\1|' )
#Path2ParentDirNOSOURCE=$(echo "$Path2currentDir" | sed 's|\(.*\)/.*|\1|' | sed 's/..\/_Source//g')
#PathWithNoSourceFolder=$(echo "$Path2currentDir"| sed 's/..\/_Source//g')
#
#echo "${white}---> \$Path2currentDir                         : ${orange}$Path2currentDir"
#echo "${white}---> \$PathWithNoSourceFolder                  : ${orange}$PathWithNoSourceFolder"
#echo "${white}---> \$Path2currentDir                         : ${orange}$Path2currentDir"
#echo "${white}---> Processing file                           : ${orange}$thefilelist"
#echo "${white}---> \$Path2ParentDir                          : ${orange}$Path2ParentDirNOSOURCE"
#echo "${white}---> Processing file                           : ${orange}$thefilelist"

echo "removing Disk infos"
if [ -f tmp/disc.csv ]
then
rm tmp/disc.csv
fi
if [ -f tmp/DISC.csv ]
then
rm tmp/DISC.csv
fi
if [ -f tmp/Disc.csv ]
then
rm tmp/Disc.csv
fi
if [ -f tmp/current_track.csv ]
then
rm tmp/current_track.csv
fi
if [ -f tmp/tmp/Current_Genre.csv ]
then
rm tmp/Current_Genre.csv
fi
if [ -f tmp/DISCTOTAL.csv ]
then
rm tmp/DISCTOTAL.csv
fi
if [ -d tmp/_album_info ]
then
rm -R tmp/_album_info
fi
if [ -d tmp/_info_Artist ]
then
rm -R tmp/_info_Artist
fi
mkdir -p ../_Output ../_Processed tmp/_album_info/img tmp/_info_Artist/img
if [ -f tmp/current_artist.csv ]
then
rm tmp/current_artist.csv
fi
if [ -f tmp/track.csv ]
then
rm tmp/track.csv
fi

echo "$white---> Processing file ffprobe                    : "${orange}""$thefilelist""
ffprobe "$thefilelist" > tmp/temp_info.txt 2>&1
cat tmp/temp_info.txt | awk '/    /' | awk '/:/' |awk '!/iTunes/'|awk '!/encoded_by/'|awk '!/iTunNORM/'|awk '!/Metadata/'|awk '!/encoder/'|awk '!/Video: /'|awk '!/builtwithAppleclangversion/'|awk '!/compatible_brands/'|awk '!/temp_info/'|awk '!/vendor_id/'|awk '!/major_brand/'|awk '!/minor_version/'|awk '!/Stream\#0/'|awk '!/iTunPGAP/'|awk '!/iTunSMPB/'> tmp/temp_infotmp.txt
cat tmp/temp_info.txt | awk '/Duration/' | awk -F',' '{print $1}' >> tmp/temp_infotmp.txt
cat tmp/temp_info.txt | awk '/Stream/' >> tmp/temp_infotmp.txt
mv tmp/temp_infotmp.txt tmp/temp_info.txt
# Bash tmp for source
echo "thefilelist=\"$thefilelist\"" > tmp/tmp_Bash
echo "$white---> Creating file file Fields                  : "${orange}"./ffprobeFields.sh"

./ffprobeFields.sh

echo "${white}---> Rapatriment des variables                : "${orange}"./ffprobeFields.sh"
echo "${white}---> source tmp/tmp_Bash"

source tmp/tmp_Bash

echo "${white}---> Cleanup"
if [ -f "tmp/Stream#0.csv" ]
then
rm "tmp/Stream#0.csv"
fi
if [ -f "tmp/creation_time.csv" ]
then
rm "tmp/creation_time.csv"
fi

searchAlbummachinename=$( echo "https://www.discogs.com/search?q=$Album_Title" |sed "s/\]/%5B/g"|sed "s/\[/%5D/g" |sed "s/'/%27/g" |sed 's/&/%26/g' | sed 's/ /%20/g')
searchArtistmachinename=$( echo "$Artist" |sed "s/\]/%5B/g"|sed "s/\[/%5D/g" |sed "s/'/%27/g" |sed 's/&/%26/g' | sed 's/ /%20/g')
# Artist ID
# If exist
# Si l'artist est déjà identifié
# Chemin vers l'abum source
if [ -f ""$Path2album"/_album_info/_info_Artist/artist_TID.csv" ]
then
ArtistID=$(cat ""$Path2album"/_album_info/_info_Artist/artistID.csv"| awk  'NR == 2')
else
curl -o tmp/SearchResultArtist -LO "https://www.discogs.com/fr/artist/"$searchArtistmachinename""
cat tmp/SearchResultArtist | awk '/"@id": "https:\/\/www.discogs.com\/fr\/artist/' | awk -F'https' '{print "https"$2}'| awk -F'"' '{print $1}' |awk '{print $1}' |awk 'NR == 1' > tmp/_info_Artist/AddressArtist.txt
AddressPageArtist=$(cat tmp/_info_Artist/AddressArtist.txt)
echo "$white---> Address Page Artist                        : $orange$AddressPageArtist"
ArtistID=$(echo "$AddressPageArtist"| awk -F'/artist/' '{print $2}' )
fi
ArtistMachineName=${ArtistID#*-}
Artist_TID=$(echo "$ArtistID"| awk -F'-' '{print $1}' )
echo "$white---> Artist ID discogs.com                    : $orange$ArtistID"
echo "$white---> Artist TID                               : $orange$Artist_TID"
echo "$white---> Artist machine-name                      : $orange$ArtistMachineName"
echo "ArtistID
$ArtistID" > tmp/_info_Artist/artistID.csv
echo "Artist_TID
$Artist_TID" > tmp/_info_Artist/artist_TID.csv
echo "$white---> Creating artist folder (dest)              : ${orange}../_Output/"$ArtistMachineName"/_info_Artist"

mkdir -p ""$Path2album"/_album_info/img" ""$Path2album"/_album_info/_info_Artist"
mkdir -p ../_Output/"$ArtistMachineName"/_info_Artist
if [ -f ""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv" ]
then
echo "${white}---> Artist Address Found                     : ""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv""
else
echo AddressPageArtist > ""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv"
cat tmp/_info_Artist/AddressArtist.txt >> ""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv"
fi

cp tmp/_info_Artist/artist_TID.csv ""$Path2album"/_album_info/_info_Artist/"
cp tmp/_info_Artist/artistID.csv ""$Path2album"/_album_info/_info_Artist/"
cp tmp/Current_Genre.csv ""$Path2album"/_album_info/Genre.csv"
if [ -f "$Path2album"/_album_info/disc.csv ]
then
echo "${white}---> Disc info csv was found                  :${orange} "$Path2album"/_album_info/disc.csv"
DiscNumber=$(cat "$Path2album"/_album_info/disc.csv | awk  'NR == 2')
echo "${bg_red}${white}---> \$DiscNumber = $DiscNumber             ${reset}"
fi

if [ -f ""$Path2album"/_album_info/Album_Page.html" ]
then
echo "${white}---> The page is already downloaded           : ${green}"$Path2album"/_album_info/Album_Page.html"
echo "${white}---> The Html page of the album whas found    : ${orange}"$Path2album"/_album_info/ALBUM_Page.html"
AlbumADDRESS=$(cat ""$Path2album"/_album_info/Album_ADDRESS.csv" | awk  'NR == 2')
else


if [ -f ""$Path2album"/_album_info/Album_ADDRESS.csv" ]
then
AlbumADDRESS=$(cat ""$Path2album"/_album_info/Album_ADDRESS.csv" | awk  'NR == 2')
echo "${white}---> Album addre ${green}found !                      : ${orange}$AlbumADDRESS"
curl -o ""$Path2album"/_album_info/ALBUM_Page.html" -LO "$AlbumADDRESS"
else

curl -o tmp/_info_Artist/Search_result_Discogs.html -LO $searchAlbummachinename"&artist="$searchArtistmachinename
cat tmp/_info_Artist/Search_result_Discogs.html| tr -d "\n" |awk -F'id="search_results"' '{print $2}' |awk -F'pagination bottom' '{print $1}' | sed 's/data-object-type="/\
/g'| sed 's/_actions skittles/\
TOBREMOVED/g'| awk '!/TOBREMOVED/'|awk -F'<a href="/' '{print $2}' > tmp/search_results_Albumtmp
echo "${white}---> Building the result list"
if [ -f tmp/search_results_Album ]
then
rm tmp/search_results_Album
fi
while read -r theresult
do
type=$(echo $theresult | awk -F'/' '{print $1}')
TheLink=$(echo $theresult | awk -F'"' '{print "https://www.discogs.com/"$1}')
TheTitle=$(echo $theresult | awk -F'>' '{print $2}'| awk -F'<' '{print $1}')
TheArtist=$(echo $theresult | awk -F'<span title="' '{print $2}'| awk -F'"' '{print $1}')

echo "$type|$TheTitle|$TheLink|$TheArtist" |awk NF >> tmp/search_results_Album
done < tmp/search_results_Albumtmp
cat tmp/search_results_Album | sed '1d'| sed "s/&amp;/\&/g" | sed "s/&#39;/'/g" | sed 's/&#34;/"/g' > tmp/search_results_Albumtmp2
awk NF tmp/search_results_Albumtmp2 > tmp/search_results_Album
rm tmp/search_results_Albumtmp2 tmp/search_results_Albumtmp

./Menu_Select_Album.sh

cat tmp/Album_ADDRESS.csv |awk NF > ""$Path2album"/_album_info/Album_ADDRESS.csv"
AlbumADDRESS=$(cat ""$Path2album"/_album_info/Album_ADDRESS.csv" | awk  'NR == 2')
curl -o ""$Path2album"/_album_info/ALBUM_Page.html" -LO "$AlbumADDRESS"
if [ -f ""$Path2album"/_album_info/ALBUM_Page.html" ]
then
echo "MusicAlbum_ID" > "$Path2album"/_album_info/MusicAlbum_ID.csv
cat ""$Path2album"/_album_info/Album_Page.html" |tr -d "\n"|awk -F'@type":"MusicAlbum","@id"' '{print $2}'|awk -F'"' '{print $2}' >> "$Path2album"/_album_info/MusicAlbum_ID.csv
if [ -f  tmp/Album_TID.csv ]
then
cat tmp/ALBUM_ID_DISCOGS.csv |awk NF > ""$Path2album"/_album_info/"ALBUM_ID_DISCOGS.csv
cat tmp/Album_TID.csv |awk NF > ""$Path2album"/_album_info/"Album_TID.csv
rm tmp/Album_TID.csv tmp/ALBUM_ID_DISCOGS.csv
fi
Album_TID=$(cat "$Path2album"/_album_info/Album_TID.csv| awk  'NR == 2')
fi
fi
fi

if [ -f ""$Path2album"/_album_info/ALBUM_ID_DISCOGS.csv" ]
then
Album_TID=$(cat ""$Path2album"/_album_info/Album_TID.csv"| awk  'NR == 2')
ID_DISCOGS=$(cat ""$Path2album"/_album_info/ALBUM_ID_DISCOGS.csv"| awk  'NR == 2')
echo "${white}---> Album Discogs ID                         : ${orange}$ID_DISCOGS"
echo "${white}---> Album TID                                : ${orange}$Album_TID"
fi
#mkdir -p ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"

images_gallery_address=$(echo ""$AlbumADDRESS"/images")
#TID_Album=$(echo "$ID_DISCOGS"| awk -F'-' '{print "70000"$1}' )
#OutputAlbumFolder=$(echo "$ID_DISCOGS"| awk -F'-' '{print $2}' )

OutputAlbumFolderTMP=${ID_DISCOGS#*-}
OutputAlbumFolder=$(echo "$OutputAlbumFolderTMP"-"$Album_TID")
mkdir -p ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/img
## get images


# If images already exist

countimage=`ls -1 "$Path2album"/_album_info/img/ 2>/dev/null | awk '/.jpg/' | wc -l`

if [ "$countimage" -ge 1 ]
then

echo "${white}Images found in           : ${orange}"$Path2album"/img"
ls "$Path2album"/_album_info/img
else
echo $bg_red$white DOING SOMETHING$reset
curl -o tmp/image_gallery -LO "$images_gallery_address"
cat tmp/image_gallery | tr -d "\n" |awk -F'id="view_images"' '{print $2}' | sed 's/><img src="/\
/g'|awk -F'"' '{print $1}' | sed "1,1d; $d"|sed '$d' > tmp/image_listtmp
mkdir -p tmp/img
mkdir -p "$Path2album"/_album_info/img
count=00
while read imagegalleryline
do
count=$(( count+1 ))
imagename=$(echo "$ID_DISCOGS"_"$count.jpg")
curl -o "tmp/img/$imagename" -LO "$imagegalleryline"
done < tmp/image_listtmp
find tmp/img/ -name *.jpg | sed 's/\/\//\//g' | sort -V > tmp/imglist.txt
while read thelineofthefile
do
echo "${white}---> copy image ${orange}$thelineofthefile in "$Path2album"/_album_info/img/"
cp "$thelineofthefile" "$Path2album"/_album_info/img/
mv "$thelineofthefile" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/img/
done < tmp/imglist.txt
#cat tmp/imglist.txt
#mv tmp/img/* ""$Path2album"/_album_info/img/"
#cp "$Path2album"/_album_info/img/*.jpg ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/img/
fi


if [ -f "$Path2album"/_album_info/Album_Title.csv ]
then
echo "${white}---> Album Title info csv was found                  :${orange} "$Path2album"/_album_info/Album_Title.csv"
Album_Title=$(cat "$Path2album"/_album_info/Album_Title.csv | awk  'NR == 2')
echo "${bg_red}${white}---> \$Album_Title = $Album_Title             ${reset}"
fi


FileSize=$(ls -lah "$thefilelist" | awk '{print $5}'|sed 's/M/ Mo/g'|sed 's/B/ Bytes/g'|sed 's/G/ Go/g')
FilenoextTMP="${thefilelist##*/}"
fileNoExt=$(echo "$FilenoextTMP" |sed "s/.$extension//g")


GenreToFile=$(echo $Genre| sed 's/@/, /g')
ArtistsAlbum2file=$(echo $Genre| sed 's/@/, /g')

UUID=$(echo "$ID_DISCOGS"-"$DiscNumber"-"$tractNumber")

mkdir -p ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"
echo $purple Crating ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"

rsync -vrapth --update --progress "$Path2album"/_album_info/ ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info
find ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/img/ -name *.jpg | sed 's/\/\//\//g'| sort -V > tmp/imglist4couv.txt
FrontCoverImage=$(cat tmp/imglist4couv.txt| awk '/_1.jpg/')
echo $puple FrontCoverImage $FrontCoverImage
if [ -f "$FrontCoverImage" ]
then
if [ "$extension" == m4a ]
then
echo "${white}---> m4a Audio rule with image"
ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
elif [ "$extension" == ogg ]
then
echo "${white}---> OGG VOBIS Audio rule"
ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
else
ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic  -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt"."$extension"
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt"."$extension" > tmp/SOUNDFILE_BASE.txt
fi

else

if [ "$extension" == m4a ]
then
echo "${white}---> m4a Audio rule"
ffmpeg -i "$thefilelist" -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
elif [ "$extension" == ogg ]
ffmpeg -i "$thefilelist" -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
then
echo "${white}---> OGG VOBIS Audio rule"
else
ffmpeg -i "$thefilelist" -c copy -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$tractNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt"."$extension"
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$fileNoExt"."$extension" > tmp/SOUNDFILE_BASE.txt
fi
fi
convert "$FrontCoverImage" -gravity center -background transparent -resize 512x512 -extent 512x512 tmp.png
./icon.sh tmp.png ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"
./icon.sh tmp.png "$Path2album"


echo "${bg_red}${white}$thefilelist thefilelist tractNumber $tractNumber DiscNumber $DiscNumber Artist $Artist Album_Title $Album_Title extension $extension TrackTitle $TrackTitle DISCTOTAL $DISCTOTAL TRACKTOTAL $TRACKTOTAL Duration $Duration Audio $Audio LABEL $LABEL ALBUMARTIST $ALBUMARTIST YEAR $YEAR Date $Date fileNoExt $fileNoExt Path2album $red$Path2album FileSize $FileSize Genre $Genre${reset}"



# PROCESSING CSVs

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
ImageURI=$(echo "$TheFileImagesTMP"|sed 's/..\/_Output/private:\/\/Music\//g'|sed "s/'/\\\'/g"|sed 's/\/\//\//g')
echo "$red$ImageURI"






# à revoir il n'y a que 1 import d'image par album
echo "$TheFileID_fid|$TheFileImages|$ImageURI" >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/imagesfiletmp.csv
done

echo "${white}---> Adress du fichier son pour l'import PHP via :${orange} use Drupal\file\Entity\File;"
echo "${white}---> ID (fid) = 1 + Album_TID"

BaseSoundFile=$(cat tmp/SOUNDFILE_BASE.txt)
TheFileSound="${BaseSoundFile##*/}"
echo "${white}$TheFileSound"
TheFileSoundID_fid=$(echo "$ID_DISCOGS"-"$DiscNumber"-"$tractNumber")
SoundURI=$(echo "$BaseSoundFile"|sed 's/..\/_Output/private:\/\/Music\//g'|sed "s/'/\\\'/g"|sed 's/\/\//\//g')

# CSV SOUND FILE
echo "TheFileSoundID_fid|TheFileSound|SoundURI
"$TheFileSoundID_fid"|"$TheFileSound"|"$SoundURI"" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/"$DiscNumber"_"$tractNumber"_Soundfile.csv

# CSV IMAGES FILES
echo "TheFileID_fid|TheFileImages|ImageURI" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/imagesfile.csv
cat ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/imagesfiletmp.csv >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/imagesfile.csv
rm ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/imagesfiletmp.csv
ImagesFID=$(awk -F'|' '{print $1}' ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/imagesfile.csv | sed '1d'  |tr "\n" "@"|sed 's/.$//')
# CSV Taxonomy Album


echo "Album_TID|Album_Title|Album_Image|Body|ImagesFID
$Album_TID|$Album_Title|$Album_Image||$ImagesFID" > Taxonomy_AlbumTMP
# CSV Node Track Audio
echo "${white}---> NODE ID = Album_TID + Disc N# + track N#"
NodeID=$(echo "$Album_TID$DiscNumber$tractNumber")
echo "DiscNumber|tractNumber|Artist|Album_Title|TrackTitle|ALBUMARTIST|DISCTOTAL|TRACKTOTAL|Duration|Audio|LABEL|YEAR|Date|fileNoExt|Path2album|extension|FileSize|Genre|AlbumADDRESS|Album_TID|TheFileSoundID_fid|ID_DISCOGS|ImagesFID|NodeID|UUID|Artist_TID|Album_TID
$DiscNumber|$tractNumber|$Artist|$Album_Title|$TrackTitle|$ALBUMARTIST|$DISCTOTAL|$TRACKTOTAL|$Duration|$Audio|$LABEL|$YEAR|$Date|$fileNoExt|$Path2album|$extension|$FileSize|$Genre$|$AlbumADDRESS|$Album_TID|$TheFileSoundID_fid|$ID_DISCOGS|$ImagesFID|$NodeID|$UUID|$Artist_TID|$Album_TID" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_album_info/"$DiscNumber"_"$tractNumber"_NodeAudio.csv





done

if [ -f tmp/IMAGES_FILE_IMPORT_PHP ]
then
rm tmp/IMAGES_FILE_IMPORT_PHP
fi


if [ -f tmp/tmp_AUDIOFILE_IMPORT_PHP ]
then
rm tmp/tmp_AUDIOFILE_IMPORT_PHP
fi

#rsync -vrapth --update --progress zeus@192.168.1.113:/Users/zeus/WORKSHOP/1/_Output/ /MOUNT_SSD_1TO/Movies_Private/private/Music

# ASSEMBLE AUDIO NODE
find ../_Output/ -name *_NodeAudio.csv | sed 's/\/\//\//g' > tmp/all_node_Audio_list.csv
for audiolines in $(cat tmp/all_node_Audio_list.csv)
do
cat "$audiolines" | awk  'NR == 2' >> tmp/all_node_Audiotmp
done
echo "DiscNumber|tractNumber|Artist|Album_Title|TrackTitle|ALBUMARTIST|DISCTOTAL|TRACKTOTAL|Duration|Audio|LABEL|YEAR|Date|fileNoExt|Path2album|extension|FileSize|Genre|AlbumADDRESS|Album_TID|TheFileSoundID_fid|ID_DISCOGS|ImagesFID|NodeID|UUID|Artist_TID|Album_TID" > ../_Output/_AUDIO_IMPORT.csv
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

# ASSEMBLE ALBUM TAXONOMY


#if [ -f "$path2id" ]
#then
#echo "$white---> File ID                    : ${green}Found !${white} $path2id"
#ArtistID=$(cat "$path2id" | awk  'NR == 2' )
#
#
#else
#echo "$white---> File ID                    : ${orange}Not Found !"
#echo "$white---> Searching artist           : ${orange}$artist ${white}discogs.com"



# Album = "Album_TID|Album_Title|Album_Image"

# Schema PHP
#use Drupal\file\Entity\File;
#$file = File::create(['uid' => 1,'fid' => '40000', 'filename' => '04 The Question Of U.mp3', 'uri' => 'private://Music/Prince/Graffiti Bridge/04 The Question Of U.mp3', 'status' => 1,]);$file->save();


#use Drupal\file\Entity\File;
#$file = File::create(['uid' => 1,'fid' => '1546476612','uuid' => 'abc-123-144-123', 'filename' => '1-07 Slow Love.mp3', 'uri' => 'private://Music/Prince/Prince-Sign-O-The-Times-5464766/1-07 Slow Love.mp3', 'status' => 1,]);$file->save();

cd -
