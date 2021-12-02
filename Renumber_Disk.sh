read -p "disk N# ? :" Disck_Number

mkdir -p _Output
for allwave in *.flac
do
lenomseuloutput=$(echo "_Output/$allwave")
#ffmpeg -i "$allwave" "$lenomseul"
echo "$lenomseuloutput"
echo "$allwave"
ffmpeg -i "$allwave" -metadata disk="$Disck_Number" -c copy "$lenomseuloutput"
done
