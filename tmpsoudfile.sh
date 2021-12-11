#
#for soundinformation in $(cat tmp/all_sound_file_PHP_list.csv)
#do
##cat "$soundinformation" | awk  'NR == 2'
#fidlinesound=$(cat "$soundinformation" | awk  'NR == 2' |awk -F'|' '{print $1}')
#filenamelinesound=$(cat "$soundinformation" | awk  'NR == 2'|awk -F'|' '{print $2}'|sed "s/'/\\\'/g")
#urilinesound=$(cat "$soundinformation" | awk  'NR == 2'|awk -F'|' '{print $2}'|sed "s/'/\\\'/g")
#echo "\$file = File::create(['uid' => 1,'fid' => '"$fidlinesound"', 'filename' => '"$filenamelinesound"', 'uri' => '"$urilinesound"', 'status' => 1,]);\$file->save();" >> tmp/tmp_AUDIOFILE_IMPORT_PHP
#done
#echo "use Drupal\file\Entity\File;" > ../_Output/_AUDIOFILE_IMPORT.txt
#cat tmp/tmp_AUDIOFILE_IMPORT_PHP >> ../_Output/_AUDIOFILE_IMPORT.txt
#
#
##-metadata track="$tractNumber" -metadata UUID="$UUID -metadata totaltrack="$TRACKTOTAL"
#../_Output/"$ArtistMachineName"/Disc_"$DiscNumber"
#
#../_Output/"$ArtistMachineName"/"$Path2album"Disc_"$DiscNumber"
#if [ -f tmp/IMAGES_FILE_IMPORT_PHP ]
#then
#rm tmp/IMAGES_FILE_IMPORT_PHP
#fi
#
## ASSEMBLE IMAGES PHP
#find ../_Output/ -name imagesfile.csv | sed 's/\/\//\//g' > tmp/all_image_files_PHP_list.csv
#for imageinfomation in $(cat tmp/all_image_files_PHP_list.csv)
#do
#cat "$imageinfomation"| sed '1d' | while read lineimages
#do
#fidlineimage=$(echo "$lineimages" |awk -F'|' '{print $1}')
#filenamelineimage=$(echo "$lineimages" |awk -F'|' '{print $2}'|sed "s/'/\\'/g")
#urilineimage=$(echo "$lineimages" |awk -F'|' '{print $3}'|sed 's/private:\//private:\/\//g'|sed "s/'/\\\'/g")
#echo "\$file = File::create(['uid' => 1,'uuid' => '"$fidlineimage"', 'filename' => '"$filenamelineimage"', 'uri' => '"$urilineimage"', 'status' => 1,]);\$file->save();" #>> tmp/IMAGES_FILE_IMPORT_PHP
#done
#done
#echo "use Drupal\file\Entity\File;" > ../_Output/_IMAGES_FILE_IMPORT.txt
#cat tmp/IMAGES_FILE_IMPORT_PHP >> ../_Output/_IMAGES_FILE_IMPORT.txt
test=10
test=20
echo $test
