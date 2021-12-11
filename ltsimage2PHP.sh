#find  -name "*.jpg" | sed -e 's/'\''/\\'\''/g' | sed -n '/.jpg/p' | awk -F'_Output' '{print $2}' | sed -e 's/\/\///g' > "$dir"/lista.txt
#sed -e 's/..\/_Output/\\n_Output/g' "$dir"/lista.txt | awk 'NF'| sed -e 's/\\/\\/\//g'   >> "$dir"/listA.txt
#ListImage="$(cat < listA.txt)"
#for line in $ListImage
#do
#LimageName=$(echo "$line" | awk '{print $NF}' FS=/ )
#LimagePath=$(echo "$line" | sed 's|\(.*\)/.*|\1|' )
#echo "${red}$LimagePath"
#echo "${white}$LimageName"
#echo "\$file = File::create(['uid' => 1,'filename' => '""$LimageName""', 'uri' => 'private://""$LimagePath""/""$LimageName""', 'status' => 1,]);\$file->save();" | sed -e 's/"."\///g'  >> _JPG2importtmp.txt
#done

#!/bin/bash
dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)

cd "$dir"

find "MUSIC_OCTO_ALL_NEW_10_2014/iTunes/iTunes Media/Music" -name *.mp3 > ToutJPG.txt
find "MUSIC_OCTO_ALL_NEW_10_2014/iTunes/iTunes Media/Music" -name *.m4a > ToutMP4.txt

cat ToutJPG.txt | sed -e 's/MUSIC_OCTO_ALL_NEW_10_2014\/iTunes\/iTunes Media\/Music/\\nMusic/g' | sed 's/MUSIC_OCTO_ALL_NEW_10_2014\/iTunes\/iTunes Media\/Music\//Music\//g' | sed 's/\/\///g' | sed -e 's/'\''/\\'\''/g' | sed -e 's/\\n//g' | awk 'NF' > _Allfiles2ImportTMP.txt
cat ToutMP4.txt | sed -e 's/Music/\\nMusic/g' | sed 's/Music\//_Output\//g' | sed 's/\/\///g' | sed -e 's/'\''/\\'\''/g' | sed -e 's/\\n//g' | awk 'NF' >> _Allfiles2ImportTMP.txt

ListFiles="$(cat < _Allfiles2ImportTMP.txt)"

IFS=$'\n'
for line in $ListFiles
do
LimageName=$(echo "$line" | awk '{print $NF}' FS=/ )
LimagePath=$(echo "$line" | sed 's|\(.*\)/.*|\1|' )
echo $LimageName
echo $LimageName
echo "\$file = File::create(['uid' => 1,'filename' => '""$LimageName""', 'uri' => 'private://""$LimagePath""/""$LimageName""', 'status' => 1,]);\$file->save();" | sed -e 's/"."\///g'  >> _Allfiles2ImportTMP2.txt
done
#rm _Allfiles2ImportTMP.txt
echo 'use Drupal\file\Entity\File;' > _Allfileimport.txt
cat _Allfiles2ImportTMP2.txt >> _AllFileimport.txt



#rm _Allfiles2ImportTMP.txt _Allfiles2ImportTMP2.txt ToutJPG.txt ToutMP4.txt

cd -
#awk /_Output/ | awk /.mp4/ test.txt > Mp4.txt


#awk '/*.jpg*/' test.txt > jpg.txt

