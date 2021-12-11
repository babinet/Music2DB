#/bin/bash!
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
echo "${white}---> Building the result list"



album="The War"

cat ootpout"$album".html| tr -d "\n" | awk -F'id="search_results"' '{print $2}' |awk -F'pagination bottom' '{print $1}' | sed 's/data-object-type="/\
/g'| sed 's/_actions skittles/\
TOBREMOVED/g'| awk '!/TOBREMOVED/'|awk -F'<a href="/' '{print $2}' > tmp/search_results_Albumtmp


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
cat tmp/search_results_Album | sed '1d' > tmp/search_results_Albumtmp2
mv tmp/search_results_Albumtmp2 tmp/search_results_Album
#cat tmp/search_results_Albumtmp |awk -F'<a href="' '{print $2}'

# ### Menu de séléction ID ####
# ### Menu de séléction début
#source tmp_bash
echo "${reset}${white}---> Evaluation du résultat"
NbrOfResult=$(cat tmp/search_results_Album | awk 'NF' | wc -l | awk -F'\ ' '{print $1}')
echo "$NbrOfResult"
if [[ "$NbrOfResult" == "1" ]]
then
echo -e "${white}---> Nombre de résultat \$NbrOfResult\t\t\t\t\t${orange}1"
elif [[ "$NbrOfResult" < "1" ]]
then
echo -e "${white}---> \$NbrOfResult inférieur à ${red}1"
echo "NbrOfResult $NbrOfResult"
elif [[ "$NbrOfResult" -ge "1" ]]
then
#echo -e "${white}---> \$ResultatsMultiples\t$ResultatsMultiples${reset}"
ResultatsMultiples=$(cat tmp/search_results_Album | awk -F'|'  '{print $1, $2, $4,  $3}' OFS='\t|\t' )
cp tmp/search_results_Album tmp/search_results_Album0111
SELECTION=1
while read -r line; do
echo "${orange}##############################################################################################################################################
$SELECTION) $line${reset}"
((SELECTION++))
done <<< "$ResultatsMultiples"
((SELECTION--))
echo "${bg_orange}${white}
##############################################################################################################################################
#    Il y a ${NbrOfResult} résultats numéroté de 1 à ${NbrOfResult} - Choisir parmis ces choix - puis enter
##############################################################################################################################################${reset}"
read -r opt
if [[ `seq 1 $SELECTION` =~ $opt ]]; then
ResultatsMultiplesOUT=$( sed -n "${opt}p" <<< "$ResultatsMultiples" | tr -d '\t' | awk 'NF' )
echo "$ResultatsMultiplesOUT" | awk 'NF' > tmp/album_id_discogs
#cp ../.film_id ../FILM_ID.txt
SelectedID=$(
sed -n "${opt}p" <<< "$ResultatsMultiples" | awk -F'|' '{print $3}' | tr -d ' ' | tr -d '\t'
)
#awk -v selectedid="$SelectedID" -F'|' '$1 == selectedid' ../.Temp.film > ../.temp.film_prime
ID_DISCOGS=$(cat tmp/album_id_discogs| awk -F'|' '{print $4}'| awk -F'/' '{print $5}')
echo -e "${whithe}---> You have chosen\t\t\t\t\t\t$ID_DISCOGS"
Album_Output=$(cat tmp/album_id_discogs | awk -F'|' '{print $4}'| awk -F'/' '{print $5}')
AlbumTitleTitleDO=$(cat tmp/album_id_discogs| awk -F'|' '{print $2}'|sed "s/&#39;/'/g")
ArtistDO=$(cat tmp/album_id_discogs| awk -F'|' '{print $3}'|sed "s/&#39;/'/g")
AddressDO=$(cat tmp/album_id_discogs| awk -F'|' '{print $4}'|sed "s/&#39;/'/g")
images_gallery_address=$(echo ""$AddressDO"/images")
echo $purple$Album_Output
echo $purple"$AlbumTitleTitleDO"
echo $purple"$ArtistDO"
echo $purple"$AddressDO"
echo $purple"$images_gallery_address"
# get images
curl -o tmp/image_gallery -LO "$images_gallery_address"
cat tmp/image_gallery | tr -d "\n" |awk -F'id="view_images"' '{print $2}' | sed 's/><img src="/\
/g'|awk -F'"' '{print $1}' | sed "1,1d; $d"|sed '$d' > tmp/image_listtmp
count=00
mkdir -p tmp/img
echo $red $ID_DISCOGS
while read imagegalleryline
do
count=$(( count+1 ))
imagename=$(echo "$ID_DISCOGS"_"$count.jpg")

curl -o "tmp/img/$imagename" -LO "$imagegalleryline"
done < tmp/image_listtmp

# If the selected IMDB ID exist
fi #fin du menu sélection
fi

#| awk -F'<a        href="/release/' '{print $2}'| awk -F'"' '{print $1}'|awk NF
cd -

