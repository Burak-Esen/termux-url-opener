#!/bin/bash

# # #    D E F I N A T I O N S   &   C O N S T A N T S    # # #
RST='\e[m'
RED='\e[38;5;196m'
WHT='\e[38;5;255m'
BG_RED='\e[48;5;196m'
BG_BLK='\e[48;5;232m'
default_theme=('\e[38;5;57m' '\e[48;5;117m' '\e[38;5;51m' '\e[38;5;207m' '\e[38;5;156m')
theme_set1=('\e[38;5;63m' '\e[48;5;231m' '\e[38;5;207m' '\e[38;5;135m' '\e[38;5;63m')
theme_set2=(${WHT} '\e[48;5;101m' '\e[38;5;208m' '\e[38;5;136m' '\e[38;5;64m')
theme_set3=('\e[38;5;167m' '\e[48;5;153m' '\e[38;5;213m' '\e[38;5;141m' '\e[38;5;69m')
theme_set4=('\e[38;5;59m' '\e[48;5;148m' '\e[38;5;214m' '\e[38;5;142m' '\e[38;5;70m')
theme_set5=('\e[38;5;63m' '\e[48;5;231m' '\e[38;5;219m' '\e[38;5;147m' '\e[38;5;75m')
theme_set6=('\e[38;5;63m' '\e[48;5;231m' '\e[38;5;220m' '\e[38;5;148m' '\e[38;5;76m')
theme_set7=('\e[38;5;98m' '\e[48;5;45m' '\e[38;5;225m' '\e[38;5;153m' '\e[38;5;81m')
theme_set8=('\e[38;5;58m' '\e[48;5;228m' '\e[38;5;82m' '\e[38;5;154m' '\e[38;5;226m')
theme_set8=('\e[38;5;14m' '\e[48;5;57m' '\e[38;5;87m' '\e[38;5;159m' '\e[38;5;231m')
set_theme_set() {
    ind=0
    for color in $@
    do
        default_theme[$ind]=$color
        ind=$(($ind + 1))
    done
}
prttl() {
    echo -e "\e[1m${default_theme[0]}${default_theme[1]} $1 ${RST}"
}
pr1() {
    echo -e "${default_theme[2]}> $1${RST}"
}
pr2() {
    echo -e "${default_theme[3]}> $1${RST}"
}
pr3() {
    echo -e "${default_theme[4]}> $1${RST}"
}
prerr() {
    echo -e "${RED} $1${RST}"
}
set_theme_set ${theme_set7[*]}

is_package_installed() {
    package=$1
	dpkg -s $package &> /dev/null
	if [ $? -eq 0 ]
    then
		return 0
	else
		return 1
	fi
}

install_package() {
    package=$1
	is_package_installed $package
	if [ $? -eq 0 ]
    then
		pr3 "Needed package ${package} exists."
	else
		pr2 "Needed package ${package} is installing..."
		echo ""
		pr1 "Some packages may request permission to install. Enter 'Y' if it's required."
		apt-get -y install $package
		sleep 1
	fi
}

install_pip_module() {
    if ! pip list | grep "^${1}" &>/dev/null
    then
        pr2 "Installing ${1}..."
        pip install $1
        sleep 2
    else
        pr3 "Needed python module ${1} exists."
    fi
}

REQUIRED_TERMUX_PACKAGES=("termux-api" "python" "ffmpeg" "jq")
REQUIRED_PYTHON_MODULES=("yt-dlp" "scdl")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
echo ""
prttl "- TERMUX URL OPENER INSTALLER -"
echo ""
pr1 "You should install Termux via F-Droid to use updated version."
pr1 "Termux:API plugin need tobe installed also."
pr1 "Both Termux:API plugin and Termux app should have required permissions in your app settings."
echo ""
prttl "INFO:"
prerr "Storage permission is required to run this program."

echo ""
pr2 "Updating default packages..."
apt-get -y update && apt-get -y upgrade

VIDEO_STORAGE="${HOME}/storage/movies"
MUSIC_STORAGE="${HOME}/storage/music"
URL_OPENER_FOLDER="${HOME}/bin"
TEMP_FOLDER="${HOME}/.url_opener_temp"
# YTDLP_CONFIG="${HOME}/.yt-dlp"

echo ""
# install packages
for package in ${REQUIRED_TERMUX_PACKAGES[@]}
do
    install_package $package
done

echo ""
# storage
if [ ! -d "${HOME}/storage" ];
then
	pr2 "Shared storage is setting up..."
	pr2 "Be sure to give required permissions to Termux and Termux-Api plugin."
	termux-setup-storage
	sleep 5
fi

# sure needed folder exist
for folder in $VIDEO_STORAGE $MUSIC_STORAGE $URL_OPENER_FOLDER $TEMP_FOLDER
do
    if [[ ! -d $folder ]]
    then
        mkdir $folder
    fi
done

echo ""
# Python modules
for module in ${REQUIRED_PYTHON_MODULES[@]}
do
    install_pip_module $module
done

echo ""
pr2 "Installing termux-url-opener script..."

if [[ -f "${URL_OPENER_FOLDER}/termux-url-opener" ]]
then
    echo ""
    prerr "An older termux-url-opener detected..."
    mv "${URL_OPENER_FOLDER}/termux-url-opener" "${URL_OPENER_FOLDER}/termux-url-opener.old"
    prerr "It is saved as ${URL_OPENER_FOLDER}/termux-url-opener.old"
    echo ""
    pr2 "Installation continue..."
fi

curl -o "${URL_OPENER_FOLDER}/termux-url-opener" "https://raw.githubusercontent.com/Burak-Esen/termux-url-opener/refs/heads/main/termux-url-opener"
chmod +x "${URL_OPENER_FOLDER}/termux-url-opener"

echo ""
pr3 "Installation Complete!"
