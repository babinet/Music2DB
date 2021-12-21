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
echo "${bg_blue}${white}---> JE SUIS                                          : ffprobeFields.sh <---${reset}
${white}---> Je trouve les métdatas present dans le fichier audio"
source tmp/tmp_Bash
# Remove Albume info title
awk '!/      title           :/' tmp/temp_info.txt > tmp/temp_info2.txt && mv tmp/temp_info2.txt tmp/temp_info.txt

# Start Loop for analyse the file
while read thefilelist
do
S1=$(echo $thefilelist| awk -F':' '{print $1}' | tr -d ' '|awk NF | sed 's/"/\\"/g')
S2=$(echo $thefilelist| awk -F': ' '{print $2}'|awk NF)
echo "$S1
$S2" > tmp/"$S1".csv
echo "${white}---> Processing lookink for                           : $orange$thefilelist"
done < tmp/temp_info.txt
source tmp/tmp_Bash
if [ -f tmp/_album_info/DiscTotal.csv ]
then
rm tmp/_album_info/DiscTotal.csv
fi
Path2album=$(echo "$thefilelist" | sed 's|\(.*\)/.*|\1|' )

# Artist
if [ -f tmp/artist.csv ]
then
cat tmp/artist.csv | sed 's/artist/Artist/g'| sed 's/ARSTIST/Artist/g'> tmp/_info_Artist/artist.csv
cp tmp/_info_Artist/artist.csv tmp/_album_info/
mv tmp/artist.csv tmp/current_artist.csv
fi

if [ -f tmp/ARSTIST.csv ]
then
cat tmp/ARSTIST.csv | sed 's/artist/Artist/g'| sed 's/ARSTIST/Artist/g'> tmp/_info_Artist/artist.csv
cp tmp/_info_Artist/artist.csv tmp/_album_info/
mv tmp/ARSTIST.csv tmp/current_artist.csv
fi
Artist=$(cat tmp/current_artist.csv | awk  'NR == 2')

# Album Title
if [ -f tmp/ALBUM.csv ]
then
cat tmp/ALBUM.csv | sed 's/ALBUM/Album_title/g'| sed 's/album/Album_title/g' > tmp/_album_info/Album_Title.csv
fi
if [ -f tmp/album.csv ]
then
cat tmp/album.csv | sed 's/ALBUM/Album_title/g'| sed 's/album/Album_title/g' > tmp/_album_info/Album_Title.csv
fi
Album_Title=$(cat tmp/_album_info/Album_Title.csv | awk  'NR == 2')

# Disc


if [[ -f tmp/disc.csv ]]
then
cat tmp/disc.csv | awk -F'/' '{print $1}' | sed 's/DISC/Disc/g' | sed 's/disc/Disc/g' > tmp/_album_info/disctmp.csv
mv tmp/_album_info/disctmp.csv tmp/_album_info/current_disc.csv
elif [[ -f tmp/DISC.csv ]]
then
cat tmp/DISC.csv | awk -F'/' '{print $1}' | sed 's/DISC/Disc/g' | sed 's/disc/Disc/g' > tmp/_album_info/disctmp.csv
mv tmp/_album_info/disctmp.csv tmp/_album_info/current_disc.csv
elif [[ -f tmp/TPA.csv ]]
then
cat tmp/TPA.csv | awk -F'/' '{print $1}' | sed 's/TPA/Disc/g' | sed 's/tpa/Disc/g' > tmp/_album_info/disctmp.csv
mv tmp/_album_info/disctmp.csv tmp/_album_info/current_disc.csv
elif [[ -f tmp/disk.csv ]]
then
cat tmp/disk.csv | awk -F'/' '{print $1}' | sed 's/Disk/Disc/g' | sed 's/disk/Disc/g' | sed 's/DISK/Disc/g' > tmp/_album_info/disctmp.csv
mv tmp/_album_info/disctmp.csv tmp/_album_info/current_disc.csv
elif [[ -f tmp/Disc.csv ]]
then
cat tmp/Disc.csv | awk -F'/' '{print $1}' | sed 's/DISC/Disc/g' | sed 's/disc/Disc/g' > tmp/_album_info/disctmp.csv
mv tmp/_album_info/disctmp.csv tmp/_album_info/current_disc.csv
else
echo "Disc
1" > tmp/_album_info/current_disc.csv
fi

# Track
if [ -f tmp/TRACK.csv ]
then
cat tmp/TRACK.csv | awk -F'/' '{print $1}' | sed 's/track/Track/g' | sed 's/TRACK/Track/g' > tmp/_album_info/tracktmp.csv
mv tmp/_album_info/tracktmp.csv tmp/_album_info/current_track.csv
traxNumberTMP=$(cat tmp/_album_info/current_track.csv | awk  'NR == 2'| sed 's/^0*//')
fi
if [ -f tmp/track.csv ]
then
cat tmp/track.csv | awk -F'/' '{print $1}' | sed 's/track/Track/g' | sed 's/TRACK/Track/g' > tmp/_album_info/tracktmp.csv
mv tmp/_album_info/tracktmp.csv tmp/_album_info/current_track.csv
traxNumberTMP=$(cat tmp/_album_info/current_track.csv | awk  'NR == 2'| sed 's/^0*//')
fi
if [ -f tmp/Track.csv ]
then
cat tmp/Track.csv | awk -F'/' '{print $1}' | sed 's/track/Track/g' | sed 's/TRACK/Track/g' > tmp/_album_info/tracktmp.csv
mv tmp/_album_info/tracktmp.csv tmp/_album_info/current_track.csv
traxNumberTMP=$(cat tmp/_album_info/current_track.csv | awk  'NR == 2'| sed 's/^0*//')
fi
if [ -z "$traxNumberTMP" ]
then
echo "${bg_red}${white}---> There is no track N# :${orange} Enter manualy .eg:8
${reset}${white}"
read -p "Track Number : " ttracknumberinput
echo "Track
$ttracknumberinput" > tmp/current_track.csv
cp tmp/current_track.csv tmp/_album_info/current_track.csv
fi

##
### For Directories
##
traxNumber=$(cat tmp/_album_info/current_track.csv | awk  'NR == 2'| sed 's/^0*//')
# Discinfo File in source folder
if [ -f "$Path2album"/_album_info/disc.csv ]
then
echo "${white}---> disc N# information     :${green} FOUND !"
DiscNumber=$(cat "$Path2album"/_album_info/disc.csv | awk  'NR == 2')
else
DiscNumber=$(cat tmp/_album_info/current_disc.csv | awk  'NR == 2')
fi
if [ -z "$DiscNumber" ]
then
echo "${white}---> Default Disc N# is                               :${orange} 1"
DiscNumber=1
else
DiscNumber=$DiscNumber
echo "${white}---> Disc N# is                                       :${green} $DiscNumber"
fi
#
### For Directories
##
mkdir -p tmp/_album_info/Disc_"$DiscNumber"/

# TITLE TRACK
if [ -f tmp/TITLE.csv ]
then
cat tmp/TITLE.csv | sed 's/TITLE/Title/g' | sed 's/title/Title/g' | sed 's/\$/USD/g' | sed "s/\&amp;/'/g" > tmp/_album_info/title_"$DiscNumber"_"$traxNumber".csv
fi
if [ -f tmp/title.csv ]
then
cat tmp/title.csv | sed 's/TITLE/Title/g' | sed 's/title/Title/g'| sed 's/\$/USD/g'| sed "s/\&amp;/'/g" > tmp/_album_info/title_"$DiscNumber"_"$traxNumber".csv
fi
TrackTitle=$(cat tmp/_album_info/title_"$DiscNumber"_"$traxNumber".csv| awk  'NR == 2'| sed 's/\$/USD/g'| sed "s/\&amp;/'/g")

# ISRC
if [ -f tmp/ISRC.csv ]
then
ISRC=$(cat tmp/ISRC.csv| awk  'NR == 2')
fi

#DISCTOTAL
if [ -f tmp/DISCTOTAL.csv ]
then
cat tmp/DISCTOTAL.csv | sed 's/DISCTOTAL/DiscTotal/g' | sed 's/disctotal/DiscTotal/g' > tmp/_album_info/DiscTotal.csv
#rm tmp/DISCTOTAL.csv
fi
if [ -f tmp/TOTALDISCS.csv ]
then
#cat tmp/TOTALDISCS.csv | sed 's/TOTALDISCS/DiscTotal/g' | sed 's/TOTALDISCS/DiscTotal/g' > tmp/_album_info/DiscTotal.csv
rm tmp/TOTALDISCS.csv
fi
if [ -f tmp/discTotal.csv ]
then
cat tmp/discTotal.csv | sed 's/DISCTOTAL/DiscTotal/g' | sed 's/disctotal/DiscTotal/g' > tmp/_album_info/DiscTotal.csv
#rm tmp/DISCTOTAL.csv
fi
if [ -f tmp/_album_info/DiscTotal.csv ]
then
echo "$white---> DISCTOTAL             $greenFound"
else
echo "$white---> Genrating empty DISCTOTAL"
echo "DiscTotal
" > tmp/_album_info/DiscTotal.csv
fi
DISCTOTAL=$(cat tmp/_album_info/DiscTotal.csv | awk  'NR == 2')

# TRACKTOTAL
if [ -f tmp/TRACKTOTAL.csv ]
then
cat tmp/TRACKTOTAL.csv | sed 's/TRACKTOTAL/TackTotal/g' | sed 's/Tracktotal/TackTotal/g'| sed 's/tracktotal/TackTotal/g' > tmp/_album_info/Disc_"$DiscNumber"/TracksTotal.csv
rm tmp/TRACKTOTAL.csv
fi
if [ -f tmp/TOTALTRACKS.csv ]
then
cat tmp/TOTALTRACKS.csv | sed 's/TOTALTRACKS/TackTotal/g' | sed 's/totaltracks/TackTotal/g'| sed 's/tracktotal/TackTotal/g' > tmp/_album_info/Disc_"$DiscNumber"/TracksTotal.csv
rm tmp/TOTALTRACKS.csv
fi
if [ -f tmp/totaltracks.csv ]
then
cat tmp/totaltracks.csv | sed 's/TOTALTRACKS/TackTotal/g' | sed 's/totaltracks/TackTotal/g'| sed 's/tracktotal/TackTotal/g' > tmp/_album_info/Disc_"$DiscNumber"/TracksTotal.csv
rm tmp/totaltracks.csv
fi
if [ -f tmp/tracktotal.csv ]
then
cat tmp/tracktotal.csv | sed 's/TRACKTOTAL/TackTotal/g' | sed 's/Tracktotal/TackTotal/g'| sed 's/tracktotal/TackTotal/g' > tmp/_album_info/Disc_"$DiscNumber"/TracksTotal.csv
rm tmp/tracktotal.csv
fi
if [ -f tmp/_album_info/Disc_"$DiscNumber"/TracksTotal.csv ]
then
echo "$white---> TRACKTOTAL             $greenFound"
else
echo "$white---> Genrating empty TRACKTOTAL"
echo "TackTotal
" > tmp/_album_info/Disc_"$DiscNumber"/TracksTotal.csv
fi
TRACKTOTAL=$(cat tmp/_album_info/Disc_"$DiscNumber"/TracksTotal.csv | awk  'NR == 2')

# Duration
if [ -f tmp/DURATION.csv ]
then
cat tmp/DURATION.csv | sed 's/duration/Duration/g' | sed 's/DURATION/Duration/g' > tmp/_album_info/Disc_"$DiscNumber"/Duration_track_"$traxNumber".csv
rm tmp/DURATION.csv
fi
Duration=$(cat tmp/_album_info/Disc_"$DiscNumber"/Duration_track_"$traxNumber".csv | awk  'NR == 2')

# Genre
if [ -f "$Path2album/Genre.csv" ]
then
echo "${white}---> Genre found in           : ${orange}"$Path2album"/_album_info/Genre.csv"
Genre=$(cat ""$Path2album"/_album_info/Genre.csv" | awk  'NR == 2')
else

if [ -f tmp/GENRE.csv ]
then
cat tmp/GENRE.csv | sed 's/GENRE/Genre/g' | sed 's/genre/Genre/g'| sed 's/\/ /@/g'| sed 's/, /@/g'| sed 's/; /@/g' | sed 's/,/@/g'| sed 's/\//@/g'|sed 's/ \/ /@/g'> tmp/_album_info/Disc_"$DiscNumber"/Genre_track_"$traxNumber".csv
rm tmp/GENRE.csv
fi
if [ -f tmp/genre.csv ]
then
cat tmp/genre.csv | sed 's/GENRE/Genre/g' | sed 's/genre/Genre/g'| sed 's/\/ /@/g'| sed 's/, /@/g' | sed 's/,/@/g'| sed 's/\//@/g'|sed 's/ \/ /@/g' > tmp/_album_info/Disc_"$DiscNumber"/Genre_track_"$traxNumber".csv
rm cat tmp/genre.csv
fi
if [ -f tmp/_album_info/Disc_"$DiscNumber"/Genre_track_"$traxNumber".csv ]
then
echo "$white---> Genre             $greenFound"
else
echo "$white---> Genrating empty Genre"
echo "Genre
" > tmp/_album_info/Disc_"$DiscNumber"/Genre_track_"$traxNumber".csv
fi
Genre=$(cat tmp/_album_info/Disc_"$DiscNumber"/Genre_track_"$traxNumber".csv | awk  'NR == 2')
echo "Genre
$Genre" > tmp/Current_Genre.csv
fi

# Audio
echo "Audio" > audio.csv
cat tmp/temp_info.txt |awk '/Stream/' |awk  '/Audio:/' |awk  -F'Audio: ' '{print $2}' |awk -F', ' '{print $1, $2, $3, $4, $5}' >> audio.csv
mv audio.csv tmp/_album_info/Disc_"$DiscNumber"/Audio_"$traxNumber".csv
Audio=$(cat tmp/_album_info/Disc_"$DiscNumber"/Audio_"$traxNumber".csv | awk  'NR == 2')

# LABEL
if [ -f tmp/LABEL.csv ]
then
cat tmp/LABEL.csv | sed 's/LABEL/Label/g' | sed 's/label/Label/g' > tmp/_album_info/Disc_"$DiscNumber"/Label.csv
rm tmp/LABEL.csv
fi
if [ -f tmp/Label.csv ]
then
cat tmp/Label.csv | sed 's/LABEL/Label/g' | sed 's/label/Label/g' > tmp/_album_info/Disc_"$DiscNumber"/Label.csv
rm cat tmp/Label.csv
fi

if [ -f tmp/_album_info/Disc_"$DiscNumber"/Label.csv ]
then
echo "$white---> LABEL             $greenFound"
else
echo "$white---> Genrating empty LABEL"
echo "Label
" > tmp/_album_info/Disc_"$DiscNumber"/Label.csv
fi

LABEL=$(cat tmp/_album_info/Disc_"$DiscNumber"/Label.csv | awk  'NR == 2')

# Comment
if [ -f tmp/comment.csv ]
then
cat tmp/comment.csv | sed 's/comment/Comment/g' | sed 's/COMMENT/Comment/g' > tmp/_album_info/Disc_"$DiscNumber"/Comment_"$traxNumber".csv
rm tmp/comment.csv
fi
if [ -f tmp/COMMENT.csv ]
then
cat tmp/COMMENT.csv | sed 's/comment/Comment/g' | sed 's/COMMENT/Comment/g' > tmp/_album_info/Disc_"$DiscNumber"/Comment_"$traxNumber".csv
rm cat tmp/COMMENT.csv
fi
if [ -f tmp/_album_info/Disc_"$DiscNumber"/Comment_"$traxNumber".csv ]
then
echo "$white---> Comment             $Comment"
else
echo "$white---> Genrating empty Comment"
echo "Comment
" > tmp/_album_info/Disc_"$DiscNumber"/Comment_"$traxNumber".csv
fi
Comment=$(cat tmp/_album_info/Disc_"$DiscNumber"/Comment_"$traxNumber".csv | awk  'NR == 2')

# ALBUMARTIST
if [ -f tmp/ALBUMARTIST.csv ]
then
cat tmp/ALBUMARTIST.csv | sed 's/ALBUMARTIST/Album_Artist/g' | sed 's/albumartist/Album_Artist/g' > tmp/_album_info/Disc_"$DiscNumber"/Album_Artist.csv
rm tmp/ALBUMARTIST.csv
fi
if [ -f tmp/albumartist.csv ]
then
cat tmp/albumartist.csv | sed 's/ALBUMARTIST/Album_Artist/g' | sed 's/albumartist/Album_Artist/g' > tmp/_album_info/Disc_"$DiscNumber"/Album_Artist.csv
rm cat tmp/albumartist.csv
fi
if [ -f tmp/TPE1.csv ]
then
cat tmp/TPE1.csv | sed 's/TPE1/Album_Artist/g' | sed 's/tpe1/Album_Artist/g' > tmp/_album_info/Disc_"$DiscNumber"/Album_Artist.csv
rm tmp/ALBUMARTIST.csv
fi

if [ -f tmp/_album_info/Disc_"$DiscNumber"/Album_Artist.csv ]
then
echo "$white---> ALBUMARTIST             $greenFound"
else
echo "$white---> Genrating empty ALBUMARTIST"
echo "Album_Artist
" > tmp/_album_info/Disc_"$DiscNumber"/Album_Artist.csv
fi
ALBUMARTIST=$(cat tmp/_album_info/Disc_"$DiscNumber"/Album_Artist.csv | awk  'NR == 2')

# DATE
if [ -f tmp/DATE.csv ]
then
cat tmp/DATE.csv | sed 's/DATE/Date/g' | sed 's/date/Date/g' > tmp/_album_info/Disc_"$DiscNumber"/Date_"$traxNumber".csv
rm tmp/DATE.csv
fi
if [ -f tmp/date.csv ]
then
cat tmp/date.csv | sed 's/DATE/Date/g' | sed 's/date/Date/g'  > tmp/_album_info/Disc_"$DiscNumber"/Date_"$traxNumber".csv
rm cat tmp/date.csv
fi
if [ -f tmp/_album_info/Disc_"$DiscNumber"/Date_"$traxNumber".csv ]
then
echo "$white---> Date             $greenFound"
else
echo "$white---> Genrating empty Date"
echo "Date
" > tmp/_album_info/Disc_"$DiscNumber"/Date_"$traxNumber".csv
fi



Date=$(cat tmp/_album_info/Disc_"$DiscNumber"/Date_"$traxNumber".csv | awk  'NR == 2')

# YEAR
if [ -f tmp/YEAR.csv ]
then
cat tmp/YEAR.csv | sed 's/YEAR/Year/g' | sed 's/year/Year/g' > tmp/_album_info/Disc_"$DiscNumber"/Year_"$traxNumber".csv
rm tmp/YEAR.csv
fi
if [ -f tmp/year.csv ]
then
cat tmp/date.csv | sed 's/YEAR/Year/g' | sed 's/year/Year/g' > tmp/_album_info/Disc_"$DiscNumber"/Year_"$traxNumber".csv
rm cat tmp/year.csv
fi
if [ -f tmp/_album_info/Disc_"$DiscNumber"/Year_"$traxNumber".csv ]
then
echo "$white---> Year             $greenFound"
else
echo "$white---> Genrating empty Year"
echo "Year
" > tmp/_album_info/Disc_"$DiscNumber"/Year_"$traxNumber".csv
fi
YEAR=$(cat tmp/_album_info/Disc_"$DiscNumber"/Year_"$traxNumber".csv | awk  'NR == 2')


# Discogs id in id3 tag
# CSV is OVER ID3 TAGS !!!!!
#if [ -f "$Path2album"/_album_info/Album_ADDRESS.csv ]
#then
#echo "${red}---> CSV is OVER ID3 TAGS !!!!!"
#echo "${green}---> DISCOGSID has been found in                      : ${orange}"$Path2album"/_album_info/Album_ADDRESS.csv"
#else


mkdir -p "$Path2album"/_album_info/CSVs/
if [ -f tmp/DISCOGSID.csv ]
then
echo "${green}---> DISCOGSID has been found in the current ID3 tags : ${orange}tmp/DISCOGSID.csv"
if [ -f "$Path2album"/_album_info/CSVs/DISCOGSID.csv ]
then
echo "${white}---> DISCOGSID has been found in _album_info source   : ${red}"$Path2album"/_album_info/CSVs/DISCOGSID.csv"
txtfileDISCOGSID=$(cat "$Path2album"/_album_info/CSVs/DISCOGSID.csv|awk 'NR == 2'|sed 's/è/e/g'|sed 's/à/a/g'|sed 's/ç/c/g')
echo "${green}---> The DISCOGSID id in the CSVs folder will be used : ${orange}$txtfileDISCOGSID"
DISCOGSID=$(cat "$Path2album"/_album_info/CSVs/DISCOGSID.csv| awk  'NR == 2'|sed 's/è/e/g'|sed 's/à/a/g'|sed 's/ç/c/g')
echo "DISCOGSID=\"$DISCOGSID\"" >> tmp/tmp_Bash
else
cat tmp/DISCOGSID.csv |sed 's/è/e/g'|sed 's/à/a/g'|sed 's/ç/c/g' > "$Path2album"/_album_info/CSVs/DISCOGSID.csv
DISCOGSID=$(cat "$Path2album"/_album_info/CSVs/DISCOGSID.csv| awk  'NR == 2'|sed 's/è/e/g'|sed 's/à/a/g'|sed 's/ç/c/g')
echo "DISCOGSID=\"$DISCOGSID\"" >> tmp/tmp_Bash
fi
else
echo "${green}---> No DISCOGSID id found at this point"
fi


# Closing if [ -f "$Path2album"/_album_info/Album_ADDRESS.csv ]
#fi

# bash_tmp profile
source tmp/tmp_Bash
extension="${thefilelist##*.}"

echo "FileSize
$FileSize" > tmp/_album_info/Disc_"$DiscNumber"/FileSize_"$traxNumber".csv
cat tmp/tmp_Bash > tmp/tmp_Bash2
echo "Path2album=\"$Path2album\"
traxNumber=\"$traxNumber\"
DiscNumber=\"$DiscNumber\"
Artist=\"$Artist\"
extension=\"$extension\"
DISCTOTAL=\"$DISCTOTAL\"
TRACKTOTAL=\"$TRACKTOTAL\"
Duration=\"$Duration\"
Genre=\"$Genre\"
Audio=\"$Audio\"
LABEL=\"$LABEL\"
COMMENT=\"$COMMENT\"
ALBUMARTIST=\"$ALBUMARTIST\"
Date=\"$Date\"
YEAR=\"$YEAR\"
FileSize=\"$FileSize\"
ISRC=\"$ISRC\"
DISCOGSID=\"$DISCOGSID\"
" >> tmp/tmp_Bash2
echo "TrackTitle=\$(cat tmp/_album_info/title_\"\$DiscNumber\"_\"\$traxNumber\".csv| awk  'NR == 2')" >> tmp/tmp_Bash2
echo "Album_Title=\$(cat tmp/_album_info/Album_Title.csv| awk  'NR == 2')" >> tmp/tmp_Bash2
mv tmp/tmp_Bash2 tmp/tmp_Bash

cd - &>/dev/null
