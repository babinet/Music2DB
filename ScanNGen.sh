#!/bin/bash -e
# wget -O A test/-tid?tid=4819094
# sed 's/\&#8230;/…/g'
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
parentdir="$(dirname "$dir")"
if [ -d tmp ]
then
rm -R tmp
fi

mkdir -p tmp ../_Trash_Temp
for directory in "$parentdir"/_Source/*/
do

if [ -f tmp/info_support.csv ]
then
rm tmp/info_support.csv
fi



echo "$white################################################################################
# WORKING IN $directory directory
################################################################################"
find "$directory" -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif"   | sed 's/\/\//\//g' > tmp/listtmp.txt

IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for thefilelist in $(cat tmp/listtmp.txt)
do
Path2currentDir=$(echo "$thefilelist" | sed 's|\(.*\)/.*|\1|' )
Path2ParentDirNOSOURCE=$(echo "$Path2currentDir" | sed 's|\(.*\)/.*|\1|' | sed 's/..\/_Source//g')
PathWithNoSourceFolder=$(echo "$Path2currentDir"| sed 's/..\/_Source//g')
#

echo "${white}---> \$Path2currentDir                                 : ${orange}$Path2currentDir"
echo "${white}---> \$PathWithNoSourceFolder                          : ${orange}$PathWithNoSourceFolder"
echo "${white}---> \$Path2currentDir                                 : ${orange}$Path2currentDir"
echo "${white}---> \$Path2ParentDirNOSOURCE                          : ${orange}$Path2ParentDirNOSOURCE"
echo "${white}---> Processing file                                  : ${orange}$thefilelist"

echo "${bg_red}${white}--->"\ "🗑"\ " Removing old disk info"\ "🗑"\ " <---${reset}"
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
if [ -f tmp/current_artist.csv ]
then
rm tmp/current_artist.csv
fi
if [ -f tmp/track.csv ]
then
rm tmp/track.csv
fi
if [ -d tmp/img ]
then
rm -R tmp/img
fi

mkdir -p ../_Output ../_Processed tmp/_album_info/img tmp/_info_Artist/img




echo "${white}---> Processing file with ffprobe                     : "${orange}""$thefilelist""
ffprobe "$thefilelist" > tmp/temp_info.txt 2>&1
cat tmp/temp_info.txt | awk '/    /' | awk '/:/' |awk '!/iTunes/'|awk '!/encoded_by/'|awk '!/iTunNORM/'|awk '!/Metadata/'|awk '!/encoder/'|awk '!/Video: /'|awk '!/builtwithAppleclangversion/'|awk '!/compatible_brands/'|awk '!/temp_info/'|awk '!/vendor_id/'|awk '!/id3v2_priv/'|awk '!/major_brand/'|awk '!/minor_version/'|awk '!/Stream\#0/'|awk '!/iTunPGAP/'|awk '!/iTunSMPB/'> tmp/temp_infotmp.txt
cat tmp/temp_info.txt | awk '/Duration/' | awk -F',' '{print $1}' >> tmp/temp_infotmp.txt
cat tmp/temp_info.txt | awk '/Stream/' | awk '!/ : Album cover/' >> tmp/temp_infotmp.txt
mv tmp/temp_infotmp.txt tmp/temp_info.txt
# Bash tmp for source
echo "$thefilelist"
thefilelist2export=$(echo "$thefilelist"| sed 's/"/\\"/g'| sed "s/'/\\'/g" )
echo "thefilelist=\"$thefilelist2export\"" > tmp/tmp_Bash
echo "${white}---> Creating file Fields                             : ${orange}./ffprobeFields.sh"

./ffprobeFields.sh

echo $red DISCOGSID DISCOGSID DISCOGSID DISCOGSID $DISCOGSID "$Path2album"/_album_info/Album_ADDRESS.csv



echo "${white}---> Rapatriment des variables from                   : ${orange}./ffprobeFields.sh"
echo "${green}---> source nouvell variables in                      ${white}: ${orange}tmp/tmp_Bash"
source tmp/tmp_Bash


if [ -f "$Path2album"/_album_info/Album_ADDRESS.csv ]
then
AlbumADDRESS=$(cat "$Path2album"/_album_info/Album_ADDRESS.csv| awk  'NR == 2')
DISCOGSID="${AlbumADDRESS##*/}"
echo $red DISCOGSID DISCOGSID DISCOGSID DISCOGSID $DISCOGSID
fi



if [ "$DISCOGSID" == "" ]
then
echo "${orange}---> Discogs ID \$DISCOGSID is NULL at this point"
elif [ "$DISCOGSID" == *"é"* ]
then
DISCOGSID=$(echo "$DISCOGSID"| awk  'NR == 2'|sed 's/è/e/g'|sed 's/à/a/g'|sed 's/ç/c/g')

else
echo "${green}---> Discogs ID \$DISCOGSID is                         ${white}: ${orange}$DISCOGSID"
echo "DISCOGSID"=\"$DISCOGSID\" >> tmp/tmp_Bash
AdressReleaseDiscogs=$(echo "https://www.discogs.com/release/"$DISCOGSID)
echo "${green}---> The release addres on discogs is                 ${white}: ${orange}$AdressReleaseDiscogs"
echo "AdressReleaseDiscogs
$AdressReleaseDiscogs" > ""$Path2album"/_album_info/Album_ADDRESS.csv"
echo "AdressReleaseDiscogs=\"$AdressReleaseDiscogs\"">> tmp/tmp_Bash
fi



if [ -f "$Path2album"/_album_info/Album_Artist.csv ]
then
Artist=$(cat "$Path2album"/_album_info/Album_Artist.csv| awk  'NR == 2')
echo "${white}---> Album Artist : ${green}$Artist ${white}was manually created and will be used for this track / album"
cp "$Path2album"/_album_info/Album_Artist.csv tmp/current_artist.csv
cp "$Path2album"/_album_info/Album_Artist.csv tmp/artist.csv
echo "Artist=\"$Artist\"" >> tmp/tmp_Bash
fi

ParentDir2Album=$(dirname "$Path2album")
Parent2Disc=$(dirname "$ParentDir2Album")
echo "${white}---> Cleanup"
if [ -f "tmp/Stream#0.csv" ]
then
rm "tmp/Stream#0.csv"
fi
if [ -f "tmp/creation_time.csv" ]
then
rm "tmp/creation_time.csv"
fi

Album_TitleMachineName=$(echo $Album_Title|sed "s/\]/%5B/g"|sed "s/\[/%5D/g" |sed "s/'/%27/g" |sed 's/&/%26/g' | sed 's/ /%20/g')
searchAlbummachinename=$( echo "https://www.discogs.com/search?limit=100\&type=all\&title=$Album_TitleMachineName" |tr -d '\')
searchArtistmachinename=$( echo "$Artist" |sed "s/\]/%5B/g"|sed "s/\[/%5D/g" |sed "s/'/%27/g" |sed 's/&/%26/g' | sed 's/ /%20/g'|tr -d '\')

# Artist ID
# If exist
# Si l'artist est déjà identifié
# Chemin vers l'abum source

if [ -f ""$Path2album"/_album_info/_info_Artist/artist_TID.csv" ]
then
ArtistID=$(cat ""$Path2album"/_album_info/_info_Artist/artistID.csv"| awk  'NR == 2')
AddressPageArtist=$(echo "https://www.discogs.com/artist/"$ArtistID)
else
curl -o tmp/SearchResultArtist -LO "https://www.discogs.com/fr/artist/"$searchArtistmachinename""
cat tmp/SearchResultArtist | awk '/"@id": "https:\/\/www.discogs.com\/fr\/artist/' | awk -F'https' '{print "https"$2}'| awk -F'"' '{print $1}' |awk '{print $1}' |awk 'NR == 1' | sed 's/\\u00e9/e/g'| sed 's/\\u00e8/e/g' > tmp/_info_Artist/AddressArtist.txt
cat tmp/SearchResultArtist | awk '/"@id": "https:\/\/www.discogs.com\/fr\/artist/' | awk -F'https' '{print "https"$2}'| awk -F'"' '{print $1}' |awk '{print $1}' |awk 'NR == 1'
AddressPageArtist=$(cat tmp/_info_Artist/AddressArtist.txt)
echo "$white---> Address Page Artist                              : ${orange}$AddressPageArtist"
ArtistID=$(echo "$AddressPageArtist"| awk -F'/artist/' '{print $2}' )
fi

ArtistMachineName=${ArtistID#*-}
if [ -f ""$Path2album"/_album_info/Various.csv" ]
then
ArtistMachineName="Various"
fi

Artist_TID=$(echo "$ArtistID"| awk -F'-' '{print $1}' )
echo "$white---> Address Page Artist                              : ${orange}$AddressPageArtist"
echo "$white---> Artist ID discogs.com                            : ${orange}$ArtistID"
echo "$white---> Artist TID                                       : ${orange}$Artist_TID"
echo "$white---> Artist machine-name                              : ${orange}$ArtistMachineName"
echo "ArtistID
$ArtistID" > tmp/_info_Artist/artistID.csv
echo "Artist_TID
$Artist_TID" > tmp/_info_Artist/artist_TID.csv
echo "$white---> Creating artist folder (dest)                    : ${orange}../_Output/"$ArtistMachineName"/_info_Artist"

mkdir -p ""$Path2album"/_img" ""$Path2album"/_album_info/_info_Artist"
mkdir -p ../_Output/"$ArtistMachineName"/_info_Artist
if [ -f ""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv" ]
then
echo "${white}---> Artist Address Found                             : ${orange}""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv""
else
echo AddressPageArtist > ""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv"
cat tmp/_info_Artist/AddressArtist.txt >> ""$Path2album"/_album_info/_info_Artist/AddressPageArtist.csv"
fi

cp tmp/_info_Artist/artist_TID.csv ""$Path2album"/_album_info/_info_Artist/"
cp tmp/_info_Artist/artistID.csv ""$Path2album"/_album_info/_info_Artist/"
cp tmp/Current_Genre.csv ""$Path2album"/_album_info/Genre.csv"
if [ -f "$Path2album"/disc.csv ]
then
echo "${white}---> Disc info csv was found                          :${orange} "$Path2album"/disc.csv"
DiscNumber=$(cat "$Path2album"/disc.csv | awk  'NR == 2')
echo "${bg_red}${white}---> \$DiscNumber = $DiscNumber             ${reset}"
fi

if [ -f ""$Path2album"/_album_info/Album_Page.html" ]
then
echo "${white}---> The page is already downloaded                   : ${green}"$Path2album"/_album_info/Album_Page.html"
echo "${white}---> The Html page of the album whas found            : ${orange}"$Path2album"/_album_info/ALBUM_Page.html"
AlbumADDRESS=$(cat ""$Path2album"/_album_info/Album_ADDRESS.csv" | awk  'NR == 2')
else

if [ -f ""$Path2album"/_album_info/Album_ADDRESS.csv" ]
then
AlbumADDRESS=$(cat ""$Path2album"/_album_info/Album_ADDRESS.csv" | awk  'NR == 2')
echo "ALBUM_ID_DISCOGS" > tmp/ALBUM_ID_DISCOGS.csv
tmpID="${AlbumADDRESS##*/}"
echo "$tmpID" >> tmp/ALBUM_ID_DISCOGS.csv
echo "Album_TID" > tmp/Album_TID.csv
echo "$tmpID" | awk -F'-' '{print $1}' >> tmp/Album_TID.csv
cp tmp/Album_TID.csv ""$Path2album"/_album_info/Album_TID.csv"
cp tmp/ALBUM_ID_DISCOGS.csv "$Path2album"/_album_info/ALBUM_ID_DISCOGS.csv
ID_DISCOGS=$(cat "$Path2album"/_album_info/ALBUM_ID_DISCOGS.csv| awk  'NR == 2'|sed 's/è/e/g'|sed 's/à/a/g'|sed 's/ç/c/g')
echo "DISCOGSID"=\"$DISCOGSID\" >>tmp/tmp_Bash
Album_TID=$(cat "$Path2album"/_album_info/Album_TID.csv | awk  'NR == 2')
OutputAlbumFolderTMP=${ID_DISCOGS#*-}
OutputAlbumFolder=$(echo "$OutputAlbumFolderTMP"-"$Album_TID")
echo "${white}---> Album address ${green}found !                            : ${orange}$AlbumADDRESS"
curl -o ""$Path2album"/_album_info/ALBUM_Page.html" -LO "$AlbumADDRESS"
else
searchAddresAlbumArtist=$(echo "$searchAlbummachinename\&artist=$searchArtistmachinename"|tr -d '\')
curl -o tmp/_info_Artist/Search_result_Discogs.html -LO $searchAddresAlbumArtist
echo "${white}---> Searching searchAddresAlbumArtist                   : ${orange}$searchAddresAlbumArtist"
echo "${white}---> Searching adress                                    : ${orange}$searchAlbummachinename\&artist=$searchArtistmachinename"
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
echo "$MusicAlbum_ID" > "$Path2album"/_album_info/MusicAlbum_ID.csv
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
ID_DISCOGS=$(cat ""$Path2album"/_album_info/ALBUM_ID_DISCOGS.csv"| awk  'NR == 2'|sed 's/é/e/g'|sed 's/è/e/g'|sed 's/à/a/g')


echo $purple $DISCOGSID DISCOGSID



echo "${white}---> Album Discogs ID                                 : ${orange}$ID_DISCOGS"
echo "${white}---> Album TID                                        : ${orange}$Album_TID"
echo "ID_DISCOGS"=\"$ID_DISCOGS\" >> tmp/tmp_Bash
echo "DISCOGSID"=\"$ID_DISCOGS\" >> tmp/tmp_Bash
fi
images_gallery_address=$(echo ""$AlbumADDRESS"/images")
OutputAlbumFolderTMP=${ID_DISCOGS#*-}
OutputFoldrNameLength=$(echo "$OutputAlbumFolderTMP"-"$Album_TID" | awk '{print length}')
if [ "$OutputFoldrNameLength" -ge 65 ]
then
OutputAlbumFolder="$Album_TID"
echo "${red}---> The OutputFoldrNameLength is $OutputFoldrNameLength chars long"
elif [[ $OutputAlbumFolderTMP =~ ['!@#$%^&*()_+'] ]]
then
OutputAlbumFolder="$Album_TID"
echo "${red}---> Percent in name % in                               : ${green}$OutputAlbumFolder"
else

OutputAlbumFolder=$(echo "$OutputAlbumFolderTMP"-"$Album_TID" | sed 's/\$/USD/g'|sed 's/û/u/g'|sed 's/ê/e/g'| iconv -f UTF-8 -t ascii//TRANSLIT//IGNORE|sed 's/"//g'|sed "s/\`//g")
if [[ $OutputAlbumFolder == *"'"* ]]
then
OutputAlbumFolder="$Album_TID"
echo "${red}---> Single quote ' in the folder name ${white}-> changed to  : ${green}$OutputAlbumFolder"

fi

fi
mkdir -p ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img

## get images
# If images already exist
countimage=`ls -1 "$Path2album"/_img/ 2>/dev/null | awk '/.jpg/' | wc -l`
#mkdir -p ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img
if [ "$countimage" -ge 1 ]
then
find "$Path2album"/_img/ -name *.jpg | sed 's/\/\//\//g' | sort -V > tmp/imglist.txt
echo "${white}---> Images found in                                  : ${orange}"$Path2album"/_img"

while read thelineofthefile
do
echo "${white}---> Copy images from source in                       : ${orange}../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/"
cp "$thelineofthefile" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/
done < tmp/imglist.txt

else
echo "${bg_green}${white}---> Downloading images from Discogs.com <---$reset"
curl -o tmp/image_gallery -LO "$images_gallery_address"
cat tmp/image_gallery | tr -d "\n" |awk -F'id="view_images"' '{print $2}' | sed 's/><img src="/\
/g'|awk -F'"' '{print $1}' | sed "1,1d; $d"|sed '$d' > tmp/image_listtmp
mkdir -p tmp/img
mkdir -p "$Path2album"/_img
count=00
while read imagegalleryline
do
count=$(( count+1 ))
imagename=$(echo "$Album_TID"_"$count.jpg")
curl -o "tmp/img/$imagename" -LO "$imagegalleryline"
done < tmp/image_listtmp

find tmp/img/ -name *.jpg | sed 's/\/\//\//g' | sort -V > tmp/imglist.txt

while read thelineofthefile
do
echo "${white}---> copy images in                                   : ${orange}../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/"
cp "$thelineofthefile" "$Path2album"/_img/
cp "$thelineofthefile" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/
done < tmp/imglist.txt

fi

if [ -f "$Path2album"/_album_info/Album_Title.csv ]
then
echo "${white}---> Album Title info csv was found                  :${orange} "$Path2album"/_album_info/Album_Title.csv"
Album_Title=$(cat "$Path2album"/_album_info/Album_Title.csv | awk  'NR == 2')
echo "${bg_red}${white}---> \$Album_Title = $Album_Title             ${reset}"
fi

if [ -f "$Path2album"/_album_info/totaldisks.csv ]
then
echo "${white}---> Totaldisks info csv was found                  :${orange} "$Path2album"/_album_info/totaldisks.csv"
DISCTOTAL=$(cat "$Path2album"/_album_info/totaldisks.csv | awk  'NR == 2')
echo "${bg_red}${white}---> \$totaldisks = $totaldisks             ${reset}"
fi

if [ -f "$Path2album"/_album_info/compilation.csv ]
then
echo "${white}---> Compilation info csv was found                  :${orange} "$Path2album"/_album_info/compilation.csv"
compilation=$(cat "$Path2album"/_album_info/compilation.csv | awk  'NR == 2')
echo "${bg_red}${white}---> \$compilation = $compilation             ${reset}"
compilationUUID=$(echo "$Album_TID$DiscNumber")
fi

echo "${white}---> ISRC                                             :${orange} $ISRC"

ArtistsAlbum2file=$(echo $ALBUMARTIST| sed 's/@/, /g')
#
UUID=$(echo "$ID_DISCOGS"-"$DiscNumber"-"$traxNumber"|sed 's/û/u/g'|sed 's/ê/e/g'| iconv -f UTF-8 -t ascii//TRANSLIT//IGNORE|sed 's/"//g'|sed "s/\`//g")
if [[ $UUID =~ ['!@#$%^&*()_+'] ]]
then
UUID=$(echo "$Album_TID"-"$DiscNumber"-"$traxNumber")
echo "${red}---> Percent in name % in   UUID     -> NEW UUID        : OutputAlbumFolder"
fi

./Album_Information.sh

ReleaseNote=$(cat "$Path2album"/_album_info/releaseNote.csv| awk  'NR == 2')
BarCode=$(cat "$Path2album"/_album_info/barcodelines.csv| awk  'NR == 2')

mkdir -p ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"
echo "${white}---> Creating Output folder                           : ${orange}../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"${white}"
rsync -vrapth --update --progress "$Path2album"/_album_info/ ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/_album_info | pv -lep -s 42 >/dev/null

if [ -f "$Path2album"/_album_info/Front.jpg ]
then
echo "${green}---> Front Cover image found in _album_info"
cp "$Path2album"/_album_info/Front.jpg ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/Front_disc-"$DiscNumber".jpg
fi

MainArtistAddress=$(echo /artist/"$ArtistMachineName")
find ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/ -name *.jpg | sed 's/\/\//\//g'| sort -V > tmp/imglist4couv.txt

if [ -f ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/Front_disc-"$DiscNumber".jpg ]
then
FrontCoverImage="../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/Front_disc-"$DiscNumber".jpg"
else
FrontCoverImage=$(cat tmp/imglist4couv.txt| awk '/_1.jpg/')
#FontDiscImage=$(echo Front_disc-"$DiscNumber".jpg)
fi
echo "${white}---> Rsync                                            : ${orange}Done${white}"
echo "${white}---> \$FrontCoverImage found                           : ${orange}$FrontCoverImage${white}"

# Get More info from discogs html page
#./Credits.sh
./CreditsTrack_By_track.sh
source tmp/tmp_Bash

FileSize=$(ls -lah "$thefilelist" | awk '{print $5}'|sed 's/M/ Mo/g'|sed 's/B/ Bytes/g'|sed 's/G/ Go/g')

FilenoextTMP="${thefilelist##*/}"
# fileNoExt
fileNoExt=$(echo "$FilenoextTMP" |sed "s/.$extension//g"| sed 's/\$/USD/g'|sed 's/û/u/g'|sed 's/ê/e/g'| iconv -f UTF-8 -t ascii//TRANSLIT//IGNORE|sed 's/"//g'|sed "s/\`//g")
# FileOutNoExt
FileOutNoExt=$(echo "$traxNumber"_"$TrackTitle"| sed 's/\$/USD/g'|sed 's/û/u/g'|sed 's/ê/e/g'| iconv -f UTF-8 -t ascii//TRANSLIT//IGNORE|sed 's/"//g'|sed "s/\`//g" | sed 's/\//_/g')

releaseDateinfo=$(cat "$Path2album"/_album_info/CSVs/ReleaseDate.csv| awk  'NR == 2')
if [ "$releaseDateinfo" == "" ]
then

input="$Date"
re='^[[:digit:]]{4}$'
if [[ $input =~ $re ]]; then
echo "${white}---> Current Date                                     : ${red}"$CurrentReleaseDate""
echo "${white}---> Changing Date to                                 : ${orange}"$CurrentReleaseDate"-01-01"
echo "ReleaseDate
"$Date"-01-01" > "$Path2album"/_album_info/CSVs/ReleaseDate.csv
else
echo "ReleaseDate
$CurrentReleaseDate" > "$Path2album"/_album_info/CSVs/ReleaseDate.csv
echo "${white}---> Date is                                   : ${orange}$CurrentReleaseDate"
fi

else
Date=$(cat "$Path2album"/_album_info/CSVs/ReleaseDate.csv| awk  'NR == 2')
fi

Genre=$(cat "$Path2album"/_album_info/CSVs/Styles.csv|awk '(NR>1)' |awk -F'|' '{print $1}'|tr '\n' '@'|sed 's/.$//')

GenreToFile=$(echo "$Genre"| sed 's/@/, /g')


if [ -f "$FrontCoverImage" ]
then
if [ "$extension" == m4a ]
then
echo "${white}---> m4a Audio rule with image"
ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$traxNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" -metadata compilation="$compilation"  -write_xing 0 ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
elif [ "$extension" == ogg ]
then
echo "${white}---> OGG VOBIS Audio rule"
ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$traxNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" -metadata compilation="$compilation"  -write_xing 0 ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
else
echo "${white}---> Encoding default with front cover"
ffmpeg -i "$thefilelist" -i "$FrontCoverImage" -map 0:a -map 1 -codec copy -metadata:s:v title="Album cover" -disposition:v attached_pic  -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$traxNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" -metadata compilation="$compilation"  -write_xing 0 ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt"."$extension"
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt"."$extension" > tmp/SOUNDFILE_BASE.txt
fi

else

if [ "$extension" == m4a ]
then
echo "${white}---> m4a Audio rule"
ffmpeg -i "$thefilelist" -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$traxNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3  -write_xing 0
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
elif [ "$extension" == ogg ]
then
echo "${white}---> OGG VOBIS Audio rule ps d'image"
ffmpeg -i "$thefilelist" -codec:v copy -codec:a libmp3lame -q:a 2 -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$traxNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3  -write_xing 0
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt".mp3 > tmp/SOUNDFILE_BASE.txt
else
echo "${white}---> pas d'image ffmpeg -c copy"
ffmpeg -i "$thefilelist" -c copy -metadata title="$TrackTitle" -metadata album="$Album_Title" -metadata track="$traxNumber" -metadata UUID="$UUID" -metadata totaltrack="$TRACKTOTAL" -metadata DISCOGSID="$ID_DISCOGS" -metadata genre="$GenreToFile" -metadata artist="$Artist" -metadata composer="$ArtistsAlbum2file" -metadata date="$Date" -metadata totaldisks="$DISCTOTAL" -metadata disk="$DiscNumber" ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt"."$extension"  -write_xing 0
echo ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/"$FileOutNoExt"."$extension" > tmp/SOUNDFILE_BASE.txt
fi
fi
if [ -f "$fontcovercompilation" ]
then
convert "$FrontCoverImage" -gravity center -background transparent -resize 512x512 -extent 512x512 tmp.png
./icon.sh tmp.png ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"
fi
FrontCoverImage=$(cat tmp/imglist4couv.txt| awk '/_1.jpg/')
convert "$FrontCoverImage" -gravity center -background transparent -resize 512x512 -extent 512x512 tmp.png
./icon.sh tmp.png ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"
./icon.sh tmp.png "$Path2album"

echo "$purple BBB ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/_album_info/"$DiscNumber"_"$traxNumber"_NodeAudio.csv"

# PROCESSING CSVs
IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for TheFileImagesTMP in $(cat tmp/imglist4couv.txt)
do
TheFileImages="${TheFileImagesTMP##*/}"
ImageNumber=$(echo "$TheFileImages"|awk -F'_' '{print $2}'|awk -F'.' '{print $1}')

TheFileID_fid=$(echo $Album_TID"-"$ImageNumber)

if [[ $TheFileID_fid =~ ['!@#$%^&*()_+'] ]]
then
TheFileID_fid=$(echo "$Album_TID"-"$DiscNumber"-"$traxNumber")
echo "${red}---> Percent in name % in   TheFileID_fid -> NEW TheFileID_fid : OutputAlbumFolder"
fi

ImageURI=$(echo "$TheFileImagesTMP"|sed 's/..\/_Output/private:\/\/Music\//g'|sed "s/'/\\\'/g"|sed 's/\/\//\//g')
echo "${green}image found : ${white}$ImageURI"

# à revoir il n'y a que 1 import d'image par album
echo "$TheFileID_fid|$TheFileImages|$ImageURI" >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/imagesfiletmp.csv
done

echo "${white}---> Adresse du fichier son pour l'import PHP via :${orange} use Drupal\file\Entity\File;"
echo "${white}---> ID (fid) = 1 + Album_TID"

BaseSoundFile=$(cat tmp/SOUNDFILE_BASE.txt)
TheFileSound="${BaseSoundFile##*/}"
#echo "${white}$TheFileSound"
TheFileSoundID_fid=$(echo "$ID_DISCOGS"-"$DiscNumber"-"$traxNumber" |sed 's/û/u/g'|sed 's/ê/e/g'| iconv -f UTF-8 -t ascii//TRANSLIT//IGNORE|sed 's/"//g'|sed "s/\`//g")
if [[ $TheFileSoundID_fid =~ ['!@#$%^&*()_+'] ]]
then
TheFileSoundID_fid=$(echo "$Album_TID"-"$DiscNumber"-"$traxNumber")
echo "${red}---> Percent in name % in TheFileSoundID_fid -> NEW TheFileSoundID_fid : OutputAlbumFolder"
fi

SoundURI=$(echo "$BaseSoundFile"|sed 's/..\/_Output/private:\/\/Music\//g'|sed "s/'/\\\'/g"|sed 's/\/\//\//g')

# CSV SOUND FILE
echo "TheFileSoundID_fid|TheFileSound|SoundURI
"$TheFileSoundID_fid"|"$TheFileSound"|"$SoundURI"" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/_album_info/"$DiscNumber"_"$traxNumber"_Soundfile.csv

# CSV IMAGES FILES
echo "TheFileID_fid|TheFileImages|ImageURI" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/imagesfile.csv
cat ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/imagesfiletmp.csv >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/imagesfile.csv
rm ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/imagesfiletmp.csv
ImagesFID=$(awk -F'|' '{print $1}' ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_img/imagesfile.csv | sed '1d'  |tr "\n" "@"|sed 's/.$//')

CoverFID=$(echo $ImagesFID| awk -F'@' '{print $1}')

# CSV Taxonomy Album
AlbumURL=$(echo "$AlbumADDRESS"| sed 's/https:\/\/www.discogs.com//g')
TrackURL=$(echo "$AlbumURL"/"$DiscNumber"/"$traxNumber"/)
echo "Album_TID|Album_Title|Album_Image|Body|ImagesFID
$Album_TID|$Album_Title|$Album_Image||$ImagesFID" > Taxonomy_AlbumTMP
# CSV Node Track Audio
echo "${white}---> NODE ID = Album_TID + Disc N# + track N#"
NodeIDTMP=$(echo "$Album_TID$DiscNumber$traxNumber")
NodIDLength=$(echo "$NodeIDTMP"|awk '{print length}')



if [ "$NodIDLength" -ge 10 ]
then
echo "${red}---> Node ID ${orange}NodeID${red} lenght is more than 9 digits"
if [ -f ../_Output/temp_ID.txt ]
then
echo "${green}---> Temp Node ID found in                            :${orange} ../_Output/temp_ID.txt"
else
wget -O  tmp/tempID https://music.sous-paris.com/used-nid
cat tmp/tempID |awk '!/</'|awk '!/>/'|awk '!/\*/'|awk '!/x/'|awk NF|sed '1d' > ../_Output/temp_ID.txt
fi
cat ../_Output/temp_ID.txt |sort -r | head -n1 | awk '{print $1+1}' > tmp/NODEID_FROMLIST

NodeID=$(cat tmp/NODEID_FROMLIST)
echo "$NodeID" > tmp/NODEID_FROMLIST
echo "$NodeID" >> ../_Output/temp_ID.txt
echo "${green}---> temp Node ID genrated_from_list                  :${green} $NodeID"
else
NodeID=$(echo "$Album_TID$DiscNumber$traxNumber")
echo "${white}---> Deffault node id                                 :${green} $NodeID"
fi


TrackInfoArtist=$(cat tmp/Trackinfo.csv| awk  'NR == 2')
CreditAlbum=$(cat "$Path2album"/_album_info/jobe_Album.csv| awk  'NR == 2')
cat tmp/Trackinfo.csv

# Ultimate year (if not)
if [ "$YEAR" == "" ]
then
echo "${red}---> Year is empty ${white}create year from date if exist"
if [ "$Date" == "" ]
then
echo "${red}---> There is even no Date"
else
YEAR=$(echo "$Date"|awk -F'-' '{print $1}')
echo "${green}---> Year from variable \$Date                         : ${orange}$YEAR"
fi
fi

if [ -f "$Path2album"/_album_info/CSVs/YearMaster.csv ]
then
YearMaster=$(cat "$Path2album"/_album_info/CSVs/YearMaster.csv| awk  'NR == 2')
fi


# Label
if [ -f "$Path2album"/_album_info/CSVs/Labels.csv ]
then
echo "${green}---> Label found"
labellist=$(cat "$Path2album"/_album_info/CSVs/Labels.csv |awk '(NR>1)')
cat "$Path2album"/_album_info/CSVs/Labels.csv

Label1=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 2'|awk -F'|' '{print $3}')
LabeCatalogNumber1=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 2'|awk -F'|' '{print $4}')

Label2=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 3'|awk -F'|' '{print $3}')
LabeCatalogNumber2=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 3'|awk -F'|' '{print $4}')

Label3=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 4'|awk -F'|' '{print $3}')
LabeCatalogNumber3=$(cat "$Path2album"/_album_info/CSVs/Labels.csv | awk  'NR == 4'|awk -F'|' '{print $4}')
echo Label3 $Label3 $LabeCatalogNumber3 LabeCatalogNumber3 Label2 $Label2 $Label1 Label1 $LabeCatalogNumber1 LabeCatalogNumber1

fi




echo "Support_Type|ReleaseType
$support|$TypeRelease" > tmp/info_support.csv
cp tmp/info_support.csv "$Path2album"/_album_info/CSVs/info_support.csv

echo "SupportTypeRelease=\$(cat \"\$Path2album\"/_album_info/CSVs/info_support.csv| awk  'NR == 2')" >> tmp/tmp_Bash2






echo "DiscNumber|traxNumber|Artist|Album_Title|CoverFID|TrackTitle|ALBUMARTIST|DISCTOTAL|TRACKTOTAL|Duration|Audio|Label1|LabeCatalogNumber1|Label2|LabeCatalogNumber2|Label3|LabeCatalogNumber3|YEAR|Date|fileNoExt|Path2album|extension|FileSize|Genre|AlbumADDRESS|Album_TID|TheFileSoundID_fid|ID_DISCOGS|ImagesFID|NodeID|UUID|Artist_TID|Album_TID|AlbumURL|extension|TrackURL|FileOutNoExt|ISRC|compilation|compilationUUID|1_pers|1_info|2_pers|2_info|3_pers|3_info|4_pers|4_info|5_pers|5_info|6_pers|6_info|7_pers|7_info|8_pers|8_info|9_pers|9_info|10_pers|10_info|Job_10|ArtistTID_10|Job_9|ArtistTID_9|Job_8|ArtistTID_8|Job_7|ArtistTID_7|Job_6|ArtistTID_6|Job_5|ArtistTID_5|Job_4|ArtistTID_4|Job_3|ArtistTID_3|Job_2|ArtistTID_2|Job_1|ArtistTID_1|releasenoteslines|BarCode|MainArtistAddress|YearMaster|Support_Type|ReleaseType
$DiscNumber|$traxNumber|$Artist|$Album_Title|$CoverFID|$TrackTitle|$ALBUMARTIST|$DISCTOTAL|$TRACKTOTAL|$Duration|$Audio|$Label1|$LabeCatalogNumber1|$Label2|$LabeCatalogNumber2|$Label3|$LabeCatalogNumber3|$YEAR|$Date|$fileNoExt|$Path2album|$extension|$FileSize|$Genre|$AlbumADDRESS|$Album_TID|$TheFileSoundID_fid|$ID_DISCOGS|$ImagesFID|$NodeID|$UUID|$Artist_TID|$Album_TID|$AlbumURL|$extension|$TrackURL|$FileOutNoExt|$ISRC|$compilation|$compilationUUID|$TrackInfoArtist|$CreditAlbum|$ReleaseNote|$BarCode|$MainArtistAddress|$YearMaster|$SupportTypeRelease" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/_album_info/"$DiscNumber"_"$traxNumber"_NodeAudio.csv
echo "$purple../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/_album_info/"$DiscNumber"_"$traxNumber"_NodeAudio.csv"
done

if [ -f tmp/IMAGES_FILE_IMPORT_PHP ]
then
rm tmp/IMAGES_FILE_IMPORT_PHP
fi

if [ -f tmp/tmp_AUDIOFILE_IMPORT_PHP ]
then
rm tmp/tmp_AUDIOFILE_IMPORT_PHP
fi

# ASSEMBLE AUDIO NODE
find ../_Output/ -name *_NodeAudio.csv | sed 's/\/\//\//g' > tmp/all_node_Audio_list.csv
for audiolines in $(cat tmp/all_node_Audio_list.csv)
do
cat "$audiolines" | awk  'NR == 2' >> tmp/all_node_Audiotmp
done
echo "DiscNumber|traxNumber|Artist|Album_Title|CoverFID|TrackTitle|ALBUMARTIST|DISCTOTAL|TRACKTOTAL|Duration|Audio|Label1|LabeCatalogNumber1|Label2|LabeCatalogNumber2|Label3|LabeCatalogNumber3|YEAR|Date|fileNoExt|Path2album|extension|FileSize|Genre|AlbumADDRESS|Album_TID|TheFileSoundID_fid|ID_DISCOGS|ImagesFID|NodeID|UUID|Artist_TID|Album_TID|AlbumURL|extension|TrackURL|FileOutNoExt|ISRC|compilation|compilationUUID|1_pers|1_info|2_pers|2_info|3_pers|3_info|4_pers|4_info|5_pers|5_info|6_pers|6_info|7_pers|7_info|8_pers|8_info|9_pers|9_info|10_pers|10_info|Job_10|ArtistTID_10|Job_9|ArtistTID_9|Job_8|ArtistTID_8|Job_7|ArtistTID_7|Job_6|ArtistTID_6|Job_5|ArtistTID_5|Job_4|ArtistTID_4|Job_3|ArtistTID_3|Job_2|ArtistTID_2|Job_1|ArtistTID_1|releasenoteslines|BarCode|MainArtistAddress|YearMaster|Support_Type|ReleaseType" > ../_Output/_AUDIO_IMPORT.csv
cat tmp/all_node_Audiotmp >> ../_Output/_AUDIO_IMPORT.csv
rm tmp/all_node_Audiotmp tmp/all_node_Audio_list.csv



# ASSEMBLE FOR THE ALBUM
find ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder" -name *_NodeAudio.csv | sed 's/\/\//\//g' > tmp/single_node_Audio_list.csv
for single_node_Audio_list in $(cat tmp/single_node_Audio_list.csv)
do
cat "$single_node_Audio_list" | awk  'NR == 2' >> tmp/single_node_Audio_listTMP
done
echo "DiscNumber|traxNumber|Artist|Album_Title|CoverFID|TrackTitle|ALBUMARTIST|DISCTOTAL|TRACKTOTAL|Duration|Audio|Label1|LabeCatalogNumber1|Label2|LabeCatalogNumber2|Label3|LabeCatalogNumber3|YEAR|Date|fileNoExt|Path2album|extension|FileSize|Genre|AlbumADDRESS|Album_TID|TheFileSoundID_fid|ID_DISCOGS|ImagesFID|NodeID|UUID|Artist_TID|Album_TID|AlbumURL|extension|TrackURL|FileOutNoExt|ISRC|compilation|compilationUUID|1_pers|1_info|2_pers|2_info|3_pers|3_info|4_pers|4_info|5_pers|5_info|6_pers|6_info|7_pers|7_info|8_pers|8_info|9_pers|9_info|10_pers|10_info|Job_10|ArtistTID_10|Job_9|ArtistTID_9|Job_8|ArtistTID_8|Job_7|ArtistTID_7|Job_6|ArtistTID_6|Job_5|ArtistTID_5|Job_4|ArtistTID_4|Job_3|ArtistTID_3|Job_2|ArtistTID_2|Job_1|ArtistTID_1|releasenoteslines|BarCode|MainArtistAddress|YearMaster|Support_Type|ReleaseType" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_Album_AUDIO_IMPORT.csv
cat tmp/single_node_Audio_listTMP >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_Album_AUDIO_IMPORT.csv
rm tmp/single_node_Audio_listTMP




# ASSEMBLE AUDIO PHP
echo $red cat source
cat tmp/tmp_Bash
echo "$purple AAA ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/Disc_"$DiscNumber"/_album_info/"$DiscNumber"_"$traxNumber"_NodeAudio.csv
../_Output/"$ArtistMachineName"/"$OutputAlbumFolder""

find ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder" -name *_Soundfile.csv | sed 's/\/\//\//g' > tmp/all_sound_file_PHP_list.csv

for soundinformation in $(cat tmp/all_sound_file_PHP_list.csv)
do
fidlinesound=$(cat "$soundinformation" | awk  'NR == 2' |awk -F'|' '{print $1}')
filenamelinesound=$(cat "$soundinformation" | awk  'NR == 2'|awk -F'|' '{print $2}'|sed "s/'/\\\'/g")
urilinesound=$(cat "$soundinformation" | awk  'NR == 2'|awk -F'|' '{print $3}'|sed "s/'/\\'/g"|sed 's/private:\//private:\/\//g')
echo "\$file = File::create(['uid' => 1,'uuid' => '"$fidlinesound"', 'filename' => '"$filenamelinesound"', 'uri' => '"$urilinesound"', 'status' => 1,]);\$file->save();" >> tmp/tmp_AUDIOFILE_IMPORT_PHP
done
echo "use Drupal\file\Entity\File;" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_Audio_import_PHP.txt
cat tmp/tmp_AUDIOFILE_IMPORT_PHP >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_Audio_import_PHP.txt


# ASSEMBLE IMAGES PHP
find ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/ -name imagesfile.csv | sed 's/\/\//\//g' > tmp/all_image_files_PHP_list.csv
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



echo "use Drupal\file\Entity\File;" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_IMAGES_import_PHP.txt
cat tmp/IMAGES_FILE_IMPORT_PHP >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_IMAGES_import_PHP.txt

echo "use Drupal\file\Entity\File;" > ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/__IMPORT_ALL_PHP.txt
cat ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_Audio_import_PHP.txt | sed '1d' >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/__IMPORT_ALL_PHP.txt
cat ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/_IMAGES_import_PHP.txt | sed '1d' >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/__IMPORT_ALL_PHP.txt

#cat tmp/IMAGES_FILE_IMPORT_PHP >> ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/__IMPORT_ALL_PHP.txt

if [ -f ../_Output/_ALL_PHP_IMPORT.txt ]
then
cat ../_Output/_ALL_PHP_IMPORT.txt | sed '1d' >> tmp/import_all_phpTMP

else
touch tmp/import_all_phpTMP
fi

cat ../_Output/"$ArtistMachineName"/"$OutputAlbumFolder"/__IMPORT_ALL_PHP.txt | sed '1d' > tmp/_ALL_TMP_PHP
cat tmp/import_all_phpTMP >> tmp/_ALL_TMP_PHP

echo "use Drupal\file\Entity\File;" > ../_Output/_ALL_PHP_IMPORT.txt
cat tmp/_ALL_TMP_PHP |awk '!seen[$0]++' >> ../_Output/_ALL_PHP_IMPORT.txt

#### Compilation ALBUM INFOS + image



awk -F'|' '{if ($33) print $0;}' ../_Output/_AUDIO_IMPORT.csv  | sed '1d' >> temp.csv
IFS=$'\n'       # Processing direcoty
set -f          # disable globbing
for TehAlbumInCompilation in $(cat temp.csv)
do
dnumber=$(echo "$TehAlbumInCompilation"  | awk -F'|' '{print $1}')
frontdisknumber=$(echo disc-"$dnumber")
termID=$(echo "$TehAlbumInCompilation"|awk -F'|' '{print $34}')
compilename=$(echo "$TehAlbumInCompilation"|awk -F'|' '{print $33}')

FidimagecouveAlbumcompile=$(echo "$TehAlbumInCompilation"  | awk -F'|' '{print $23}'|tr @ '\n' |awk -v "frontdisknumber"="$frontdisknumber" "/$frontdisknumber/"|awk NF  )
#echo $FidimagecouveAlbumcompile
echo "$FidimagecouveAlbumcompile|$termID|$compilename" >> ../_Output/_compil_IMPORTtmp.csv
#echo "$FidimagecouveAlbumcompile"
#imageUniqueID=$(cat ../_Output/_AUDIO_IMPORT.csv | awk -F'|' '{print $23}'|tr '@' '\n'| awk -v "DiscNumber"="$DiscNumber" "/$DiscNumber/")
#
#
#awk -F'|' '{print $(NF-1)"|"$NF}'  ../_Output/_AUDIO_IMPORT.csv  | awk -v "Album_TID"="$Album_TID" "/$Album_TID/"  > ../_Output/_compil_IMPORTtmp.csv
#echo "compilation|compilationUUID" > ../_Output/_compil_IMPORT.csv
#cat ../_Output/_compil_IMPORTtmp.csv >> ../_Output/_compil_IMPORT.csv
done
echo "ImageCompileUUID|compilationUUID|compilation" > ../_Output/_compil_IMPORT.csv
if [ -f ../_Output/_compil_IMPORTtmp.csv ]
then
cat ../_Output/_compil_IMPORTtmp.csv >> ../_Output/_compil_IMPORT.csv
rm ../_Output/_compil_IMPORTtmp.csv

fi
if [ -f temp.csv ]
then
rm temp.csv
fi

# Compile Artist
find ../_Output/ tmp -name credits_Artiss_list.csv -o -name artist_list_tracks.csv |sed 's/\/\//\//g' > tmp/artist2compile.list
#find "$directory" -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" -o -name "*.ogg" -o -name "*.aif"
countartist=$(cat tmp/artist2compile.list | wc -l)
if [ "$countartist" -ge 1 ]
then
echo "${white}---> Computing artist list"
IFS=$'\n'       # Processing lines
set -f          # disable globbing
for thelistofartiscsv in $(cat tmp/artist2compile.list )
do
cat "$thelistofartiscsv" |sed '1d' |awk '!seen[$0]++' >> tmp/artist_list.csv
done
echo "Artist-address|ArtistID|Artist_TID|Artist" > ../_Output/_ARTIST.CSV
cat tmp/artist_list.csv |awk '!seen[$0]++' |awk NF | sed 's/ \//\//g' >> tmp/artist_list.csvTMP #../_Output/_ARTIST.CSV
else
echo "${red}---> Ther is no artist(s)"
fi



find ../_Output/ -name credits_Artiss_list.csv |sed 's/\/\//\//g' > tmp/artist3compile.list
echo "${white}---> Computing artist Credit list"
IFS=$'\n'       # Processing lines
set -f          # disable globbing
for thelistcredit in $(cat tmp/artist3compile.list )
do
cat "$thelistcredit" |sed '1d' >> tmp/artist_credit_list.csv
done
if [ -f ../_Output/_ARTIST.CSV ]
then
cat ../_Output/_ARTIST.CSV  |sed '1d' > tmp/_ARTIST.CSV
fi
cat tmp/artist_list.csvTMP >> tmp/_ARTIST.CSV
cat tmp/artist_credit_list.csv |awk '!seen[$0]++' |awk NF | sed 's/ \//\//g' >> tmp/_ARTIST.CSV
echo "Artist-address|ArtistID|Artist_TID|Artist" > ../_Output/_ARTIST.CSV
cat  tmp/_ARTIST.CSV |sed '1d' |awk '!seen[$0]++' |awk NF >> ../_Output/_ARTIST.CSV

# LAbels List CSV
if [ -f ../_Output/_LABELS_LIST.CSV ]
then
cat ../_Output/_LABELS_LIST.CSV|awk '(NR>1)' > tmp/LABELS.TMP
fi


echo "LabeID|LabeName|LabeTID|LabeCatalogNumber|LabeURL"  |awk NF > ../_Output/_LABELS_LIST.CSV
if [ -f tmp/LABELS.TMP ]
then
cat tmp/LABELS.TMP |awk NF |awk '!seen[$0]++' >> ../_Output/_LABELS_LIST.CSV
fi
cat "$Path2album"/_album_info/CSVs/Labels.csv|awk '(NR>1)' |awk NF >> ../_Output/_LABELS_LIST.CSV



echo "$red---> Export Album info Artist + Album + PHP"

FileDate=$(echo $(date +%Y_%m_%d_%Hh%Mm%Ss) | tr "/" "_")
TrashDirectory=$(echo "$Album_Title"| tr -d '/:')
mv "$directory" ../_Trash_Temp/"$TrashDirectory"_"$FileDate"





if [ -f tmp/default_choice ]
then
rm tmp/default_choice
fi
done


if [ -f ../_Output/temp_ID.txt ]
then
rm ../_Output/temp_ID.txt
fi
cd -



