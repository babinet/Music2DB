#!/bin/bash
red=`tput setaf 1`

bg_red=`tput setab 1`
white=`tput setaf 15`

dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd "$dir"





# ### Menu de séléction ID ####
# ### Menu de séléction début
source tmp/tmp_Bash
echo "${reset}${white}---> Evaluation du résultat"
NbrOfResult=$(cat tmp/search_results_Album | awk 'NF' | wc -l | awk -F'\ ' '{print $1}')
echo "$NbrOfResult"
if [[ "$NbrOfResult" < "0" ]]
then
echo -e "${white}---> \$NbrOfResult inférieur à ${red}1"
elif [[ "$NbrOfResult" -ge "1" ]]
then
echo -e "${white}---> \$ResultatsMultiples\t$ResultatsMultiples${reset}"
ResultatsMultiples=$(cat tmp/search_results_Album | awk -F'|'  '{print $1, $4, $2, $3}' OFS='\t|\t' )
#cp tmp/search_results_Album tmp/search_results_Album0111
SELECTION=1
while read -pru line
do
echo "${orange}########################################################################################################################################################
$SELECTION) $line${reset}"
((SELECTION++))
done <<< "$ResultatsMultiples"
((SELECTION--))
echo "${bg_orange}${white}########################################################################################################################################################
#    Il y a ${NbrOfResult} résultats numéroté de 1 à ${NbrOfResult} - Choisir parmis ces choix - puis enter
########################################################################################################################################################${reset}"
read -p "Selection :" opt
if [[ `seq 1 $SELECTION` =~ $opt ]]; then
ResultatsMultiplesOUT=$( sed -n "${opt}p" <<< "$ResultatsMultiples" | tr -d '\t' | awk 'NF' )
echo "$ResultatsMultiplesOUT" | awk 'NF' > tmp/album_info

echo "album_info" >tmp/album_info_discogs.csv
cat tmp/album_info >> tmp/album_info_discogs.csv

SelectedID=$(
sed -n "${opt}p" <<< "$ResultatsMultiples" | awk -F'|' '{print $3}' | tr -d ' ' | tr -d '\t'
)
ID_DISCOGS=$(cat tmp/album_info_discogs.csv| awk -F'|' '{print $4}'| awk -F'/' '{print $5}')
echo "ALBUM_ID_DISCOGS
$ID_DISCOGS" > tmp/ALBUM_ID_DISCOGS.csv
ID_DISCOGS=$(cat tmp/album_info_discogs.csv| awk -F'|' '{print $4}'| awk -F'/' '{print $5}')
Addres_album=$(cat tmp/album_info_discogs.csv| awk -F'|' '{print $4}')
echo "Addres_album
$Addres_album" > tmp/Album_ADDRESS.csv

TID_Album=$(echo "$ID_DISCOGS"| awk -F'-' '{print $1}' )
echo "Album_TID
$TID_Album" > tmp/Album_TID.csv
echo -e "${whithe}---> You have chosen\t\t\t\t\t\t$ID_DISCOGS"
fi
fi

