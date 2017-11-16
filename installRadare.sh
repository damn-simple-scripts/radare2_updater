#!/bin/bash

if [ -z $(which radare2) ] ; then
	apt update
	apt install radare2
fi

echo "Current radare version: "
echo "$(radare2 -version)"
echo ""

read -r -p "Do you want to upgrade it via git? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]] ; then
	echo "let's to this"
else
	read -r -p "Do you want to upgrade it via apt? [y/N] " response
	response=${response,,}    # tolower
	if [[ "$response" =~ ^(yes|y)$ ]] ; then
		apt update
		apt install -y radare2 --reinstall
		echo "radare is good to go"
		echo "New radare version: "
		echo "$(radare2 -version)"
		read -r -p "press any key to exit" response
		exit
	else
		exit
	fi
fi

basedir="/opt"

if [ ! -e $basedir ] ; then
	mkdir basedir
fi

cd $basedir

if [ -e radare2 ] ; then
	cd radare2
	git pull
else
	git clone https://github.com/radare/radare2
	cd radare2
fi

sys/install.sh

cd $basedir

if [ -e radare2-extras ] ; then
	cd radare2-extras
	git pull
else
	git clone https://github.com/radare/radare2-extras
	cd radare2-extras
fi
./configure --prefix=/usr
cd yara/yara3
../install-yara3.sh
./configure --prefix=/usr
make
make install

cd $basedir

echo "radare is good to go"
echo "New radare version: "
echo "$(radare2 -version)"
read -r -p "press any key to exit" response
