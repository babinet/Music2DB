for allwave in *.wav
do
lenomseul=$(echo "$allwave"| sed 's/.wav/.flac/g')
ffmpeg -i "$allwave" "$lenomseul"
echo "$lenomseul"
echo "$allwave"
done
