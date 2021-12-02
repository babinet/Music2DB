#/bin/bash!
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
dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd $dir
echo ${white}'
        888b     d888                   d8b           .d8888b.  8888888b.  888888b.
        8888b   d8888                   Y8P          d88P  Y88b 888  "Y88b 888  "88b
        88888b.d88888                                       888 888    888 888  .88P
        888Y88888P888 888  888 .d8888b  888  .d8888b      .d88P 888    888 8888888K.
        888 Y888P 888 888  888 88K      888 d88P"     .od888P"  888    888 888  "Y88b
        888  Y8P  888 888  888 "Y8888b. 888 888      d88P"      888    888 888    888
        888   "   888 Y88b 888      X88 888 Y88b.    888"       888  .d88P 888   d88P
        888       888  "Y88888  88888P  888  "Y8888P 888888888  8888888P"  8888888P"
'

echo "${white}---> Checking install & datas..."

#Check
if [[ -f servers/osxiconutils/icns2image ]]
then
echo -e "${green}---> Osxiconutils is installed in :${orange}\t\t\t\t\t\t\t\tservers/osxiconutils"
else
echo "${orange}--->Installing Osxiconutils in servers/osxiconutils"
mkdir -p servers/osxiconutils servers/osxiconutils/temp
wget -O servers/osxiconutils.zip https://sveinbjorn.org/files/software/osxiconutils.zip
unzip servers/osxiconutils.zip -d servers/osxiconutils/temp
cp -Rap servers/osxiconutils/temp/bin/* servers/osxiconutils/
rm -R servers/osxiconutils/temp servers/osxiconutils.zip
chmod +x servers/osxiconutils/image2icns servers/osxiconutils/seticon servers/osxiconutils/icns2image servers/osxiconutils/geticon
fi


#read input_variable
#echo "You entered: $input_variable"
#
menu_from_array ()
{

select item; do
# Check menu item number
if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $# ];

then
echo "Vous avez selectioné $item"
break;
else
echo "Erreur - Choisir parmis 1-$#"
fi
done
}

# Declare the array
linux=('ScanNGen' 'Cue_Rename' 'Tracks_Number_from_Name' 'Cue_2_Tracks' 'Generate_CSV_and_Files' 'Renumber_Track' 'track_by_Track_Number' 'Mass_Print_Artists' 'FFmpef_CueSplit' 'Mass_Print_Album_N_DiscogsID' 'DeleteFields')

# Call the subroutine to create the menu
menu_from_array "${linux[@]}"

if [ $item.sh = ScanNGen.sh ]
then
./ScanNGen.sh
fi

if [ $item.sh = Cue_Rename.sh ]
then
./Cue_Rename.sh
fi
if [ $item.sh = Tracks_Number_from_Name.sh ]
then
./Tracks_Number_from_Name.sh
fi
if [ $item.sh = Cue_2_Tracks.sh ]
then
./Cue_2_Tracks.sh
fi
if [ "$item".sh = Generate_CSV_and_Files.sh ]
then
echo "${white}---> Listing ALL audios files & .jpg with path to import in Drupal in ${orange}: _Output"

./Generate_CSV_and_Files.sh
echo "${white}---> ${green} Done !"
fi
if [ "$item".sh = Rename_Album_ID3.sh ]
then
echo "${white}---> Reanme ALL audios files id3 tags for ${orange}: Album"

./Rename_Album_ID3.sh
echo "${white}---> ${green} Done !"
fi


if [ $item.sh = Renumber_Track.sh ]
then
./Renumber_Track.sh
fi
if [ $item = KeepOneZIPOnly ]
then
for DirectoryZips in `find ../_Output/*/*/*_Fields/ -type d -name "ZIPS"`
do
echo -e "${white}---> Keeping only 1 (ONE) Zip in $DirectoryZips - ${red} Deleting all older zips"
ls -t "$DirectoryZips"/*.zip | tail -n +2 | xargs rm --
done

fi
if [ $item.sh = track_by_Track_Number.sh ]
then

./track_by_Track_Number.sh
fi

if [ $item.sh = Renumber_TrackBtrack.sh ]
then

./Renumber_TrackBtrack.sh
fi



if [ $item.sh = Mass_Print_Artists.sh ]
then
./Mass_Print_Artists.sh
fi

if [ $item.sh = FFmpef_CueSplit.sh ]
then
./FFmpef_CueSplit.sh
fi



if [ $item.sh = Mass_Print_Album_N_DiscogsID.sh ]
then
./Mass_Print_Album_N_DiscogsID.sh
fi


cd -

