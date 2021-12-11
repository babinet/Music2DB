#!/bin/bash
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

if [ -f tmp/genretmp ]
then
rm tmp/genretmp
fi
if [ -f tmp/Genre_N_StyleTMP.csv ]
then
rm tmp/Genre_N_StyleTMP.csv
fi
if [ -f tmp/Genre_N_StyleTMP2.csv ]
then
rm tmp/Genre_N_StyleTMP2.csv
fi

#70000000
#curl -o tmp/Genre_Style_List_Discogs.html -LO https://blog.discogs.com/en/genres-and-styles
cat tmp/Genre_Style_List_Discogs.html | tr -d '\n'| tr -d '\r' |awk -F'<h2>Styles by Genre on Discogs</h2>' '{print $2}'|awk -F'<footer' '{print $1}'|sed 's/<h3/\
<h3/g' | sed 's/\&#038;/\&/g' | sed "s/\&#8217;/'/g" | sed 's/\&#8220;/"/g'| sed 's/\&#8221/"/g' > tmp/templist.html
IFS=$'\n'       # Processing line
set -f          # disable globbing
for ullines in $(cat tmp/templist.html)
do
Genre=$(echo "$ullines"|awk -F'>' '{print $2}' |awk -F'<' '{print $1}'|awk NF)
echo "${white}---> Genre              : ${orange}$Genre"

if [ "$Genre" == "" ]
then
echo "${white}---> There is no new Genre fro this style"
else
echo "${white}---> Genre              : ${orange}$Genre"
echo "$Genre" > tmp/genretmp
fi




if [ -tmp/genretmp ]
then
Genre=$(cat tmp/genretmp)
fi
# Genre
# Style


echo "$ullines" |tr -d '\n'| tr -d '\n'|tr -d '\r'| sed 's/https:\/\/www.discogs.com\/style/\
\/style/g' > tmp/ullines.txt
for lilines in $(cat tmp/ullines.txt)
do
Style=$(echo "$lilines"|awk -F'gsl-artist'\''>' '{print $2}' |awk -F'<' '{print $1}'|awk NF)
Style_address=$(echo "$lilines"| awk -F''\''' '{print $1}'| tr -d '\n')
echo $purple "$Style_address"
StyleDesciption=$(echo "$lilines"|awk -F'gsl-label'\''>' '{print $2}' |awk -F'<' '{print $1}'|awk NF|awk '!/Help contribute/' )
echo $white $Genre $purple style : "$Style" $red "$StyleDesciption" |awk NF
echo "$Genre|$Style|$StyleDesciption|$Style_address" |awk '/\/style\//'|awk -F'|' '$2!=""' >> tmp/Genre_N_StyleTMP.csv
done

done
cat tmp/Genre_N_StyleTMP.csv| awk -F'|' '{print $1}' |sed '1d' |awk '!seen[$1]++' |awk '{print $0"|||"}' > tmp/Genre_N_StyleTMP2.csv && cp tmp/Genre_N_StyleTMP2.csv test.txt
cat tmp/Genre_N_StyleTMP.csv >> tmp/Genre_N_StyleTMP2.csv
StartTID=70000000

IFS=$'\n'       # Processing line
set -f          # disable globbing
for theline in $(cat tmp/Genre_N_StyleTMP2.csv)
do
StartTID=$(( StartTID+1 ))
echo "$StartTID|$theline"
done >> Genre_N_StyleTowait.csv
echo "TID|Genre|Style|StyleDesciption|Style_address" > ../Genre_N_Style.csv
cat Genre_N_StyleTowait.csv >> ../Genre_N_Style.csv


if [ -f tmp/genretmp ]
then
rm tmp/genretmp
fi
if [ -f tmp/Genre_N_StyleTMP.csv ]
then
rm tmp/Genre_N_StyleTMP.csv
fi
if [ -f tmp/Genre_N_StyleTMP2.csv ]
then
rm tmp/Genre_N_StyleTMP2.csv
fi


#count=70000000
#count=$(( count+1 ))
#echo "$count"

#
#cat tmp/Genre_Style_List_Discogs.html | tr -d '\n'|tr -d '\r'| sed 's/https:\/\/www.discogs.com\/style/\
#\/style/g'|awk -F'<' '{print $1}'
