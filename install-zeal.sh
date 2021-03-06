#!/usr/bin/bash

# exit on any error
set -e

# check if root
if [ $EUID -ne 0 ]; then 
    echo -e "\e[31mThis script must be run as root\e[0m\nType: sudo bash $0"
    exit 1
fi

# check system architecture
case `dpkg --print-architecture` in
x86_64 | amd64)
    sa='amd64'
    ;;
i386)
    sa='i386'
    ;;
    *)
    echo -e "\e[31m
This installer is made for AMD64, x86_64 and i386 only!\e[0m
You can find needed packages for your PC here:
http://deb.debian.org/debian/pool/main/z/zeal/
"
    exit 1
    ;;
esac

# start the installation
echo -e "Installing Zeal...\n"

a=$(curl -s https://api.github.com/repos/zealdocs/zeal/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
url="deb.debian.org/debian/pool/main/z/zeal/zeal_${a:1}-1_${sa}.deb"
wget $url 

# ' ##*/ ' removes all characters before last ' / ' (included the ' / ')
dpkg -i ${url##*/}

rm ${url##*/}

# install dependencies
apt-get -f install

# finish and check zeal is installed or not
if ! [ `command -v zeal` ]; then
  echo -e "\e[31mSorry, Zeal is not installed.\e[0m\nTry installing it manaully."
  exit 1
else
    echo -e "\n\e[32mComplete! \e[0m \nNow you can run Zeal by typing: zeal"
fi
exit 0
