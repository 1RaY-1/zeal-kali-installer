#!/bin/bash
set -e

if [ $EUID -ne 0 ]; then 
    echo -e "\e[31mYou have to run this script with sudo\e[0m\nType: sudo bash $0"
    exit 1
fi

case `dpkg --print-architecture` in
x86_64 | amd64)
    sa='amd64'
    ;;
i386)
    sa='i386'
    ;;
    *)
    echo "\e[31m
This installer is for AMD64, x86_64 and i386 only.\e[0m
You can find needed packages for your system architecture here:
http://deb.debian.org/debian/pool/main/z/zeal/
"
    exit 1
    ;;
esac

echo -e "Installing Zeal...\n"

a=$(curl -s https://api.github.com/repos/zealdocs/zeal/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
url="deb.debian.org/debian/pool/main/z/zeal/zeal_${a:1}-1_${sa}.deb"
wget $url 

# ' ##*/ ' removes all characters before last ' / ' (included the ' / ')
dpkg -i ${url##*/}

rm ${url##*/}

# install dependencies
apt-get -f install -y

echo -e "\n\e[32mComplete!\e[0m\nNow you can run Zeal by typing: zeal"
exit 0

