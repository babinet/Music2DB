# Compile Artist
find ../_Output/ -name artist_list.csv |sed 's/\/\//\//g' > tmp/artist2compile.list
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
cat ../_Output/_ARTIST.CSV  |sed '1d' > tmp/_ARTIST.CSV
cat tmp/artist_list.csvTMP >> tmp/_ARTIST.CSV
cat tmp/artist_credit_list.csv |awk '!seen[$0]++' |awk NF | sed 's/ \//\//g' >> tmp/_ARTIST.CSV
echo "Artist-address|ArtistID|Artist_TID|Artist" > ../_Output/_ARTIST.CSV
cat  tmp/_ARTIST.CSV |sed '1d' |awk '!seen[$0]++' |awk NF >> ../_Output/_ARTIST.CSV

