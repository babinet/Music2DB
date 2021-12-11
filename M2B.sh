# Champs
# "nid|track_title|field_artist|field_album|field_cd|field_track_n|field_aut_inter|field_sound|body|field_image"
# Extract all image from music file in Output folder
eyeD3-3.9 --write-images=Output/ file.mp3
# sudo apt-get install shntool
# sudo port install cuetools
# convert Flac with .cue to individaul files

# FLAC
find . -name "*.cue" -exec sh -c 'exec shnsplit -f "$1" -o flac -t "%n_%p-%t" "${1%.cue}.flac"' _ {} \;
# APE
find . -name "*.cue" -exec sh -c 'exec shnsplit -f "$1" -o flac -t "%n_%p-%t" "${1%.cue}.flac"' _ {} \;



#Tags
ffmpeg -i SOTT\ Rehearsals\ 2.0\ Touched\ Up\ -\ CD1.flac -c copy -metadata title="My Title"  -metadata album="My Title" -metadata track=12 -metadata totaltrack=1003 -metadata genre=Frunk -metadata artist="Prince" -metadata composer="Prince & Sheila E." -metadata date=1988  -metadata totaldisks="5" -metadata disk=5 out2.flac


###
# YEAR Comment?
###
find . -type f -name '*.flac' -o -name '*.mp3'


ffmpeg -i 03_Prince-Little\ Red\ Corvette.flac -i Artist.jpg  -map_metadata 0 -map 0 -map 1 out2.mp3
