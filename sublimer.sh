#!/bin/bash

function die {
    echo $1
    exit 1
}

if [ "$(/usr/bin/id -u)" -ne "0" ]; then
    echo "Not running as root... attempting to re-launch $0 with sudo"
    sudo $0
    exit
fi

SCRIPTDIR=`pwd`

SUBLIME_URL="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2"
OUTPUT_FILENAME="sublime.tar.bz2"
MD5SUM="699cd26d7fe0bada29eb1b2cd7b50e4b"
DIR=`mktemp -d`
cd $DIR

wget $SUBLIME_URL -O $OUTPUT_FILENAME

[ $(md5sum $OUTPUT_FILENAME | cut -d ' ' -f 1) != $MD5SUM ] && die "Incorrect MD5sum."

tar xf $OUTPUT_FILENAME || die "Couldn't untar $DIR/$OUTPUT_FILENAME ..."

mv Sublime\ Text\ 2 /opt/
ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
cp $SCRIPTDIR/sublime.desktop /usr/share/applications/sublime.desktop

sed -i s/gedit\.desktop/sublime.desktop/g /usr/share/applications/defaults.list
cd $SCRIPTDIR
rm -rf $DIR
exit 0
