#!/bin/bash
#wget https://github.com/${GitUser}/
GitUser="keyjsl"
#IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
# LINE COLOUR
line=$(cat /etc/line)
# TEXT COLOUR BELOW
below=$(cat /etc/below)
# BACKGROUND TEXT COLOUR
back_text=$(cat /etc/back)
# NUMBER COLOUR
number=$(cat /etc/number)
# TEXT ON BOX COLOUR
box=$(cat /etc/box)
clear
yl='\e[031;1m'
bl='\e[36;1m'
gl='\e[32;1m'
BLUE='\e[0;34m'
clear
echo -e ""
echo -e "   \e[$line════════════════════════════════════════\e[m"
echo -e "   \e[$back_text         \e[30m═[\e[$box CHANGE PORT MENU\e[30m ]═         \e[m"
echo -e "   \e[$line════════════════════════════════════════\e[m"
echo -e "\e[$number   >>\e[$number Please select an option below :\e[0m"
echo -e "   \e[$number (•1)\e[m \e[$below Change Port Xray Core\e[m"
echo -e "   \e[$number (•2)\e[m \e[$below Change Port Trojan Go\e[m"
echo -e ""
echo -e "   \e[$line═══════════════════════════════════════\e[m"
echo -e "   \e[$back_text \e[$box x)  MENU                             \e[m"
echo -e "   \e[$line═══════════════════════════════════════\e[m"
echo -e ""
read -p "     Select From Options [1-2 or x] :  " port
echo -e ""
case $port in
1)
port-xray
;;
2)
port-trojan
;;
x)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac
