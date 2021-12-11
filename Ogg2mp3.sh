for OggFiles in *.ogg
do
mp3output=$(echo "$OggFiles" | sed 's/.ogg/.mp3/g')
echo "$mp3output"
sox "$OggFiles" "$mp3output"
done
