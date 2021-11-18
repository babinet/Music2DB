read -p "Album Title ? :" Album_Title

mkdir -p _Output
for allwave in *.flac
do
lenomseuloutput=$(echo "_Output/$allwave")
#ffmpeg -i "$allwave" "$lenomseul"
echo "$lenomseuloutput"
echo "$allwave"
ffmpeg -i "$allwave" -metadata album="$Album_Title" -c copy "$lenomseuloutput"
done
