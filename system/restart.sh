#!/bin/bash
#wget https://github.com/${GitUser}/
GitUser="keyjsl"
#IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
clear
echo -e ""
echo -e "======================================"
echo -e "         \e[0;32mRESTART VPN SERVICE\e[0m"
echo -e "======================================"
echo -e "  \e[0;32m[•1]\e[0m Restart All Services"
echo -e "  \e[0;32m[•2]\e[0m Restart Nginx"
echo -e "  \e[0;32m[•3]\e[0m Restart Vmess & Vless"
echo -e "  \e[0;32m[•4]\e[0m Restart Trojan"
echo -e "  \e[0;32m[•5]\e[0m Restart ShadowsocksR"
echo -e "======================================"
echo -e "   \e[0;32m[x]\e[0m     \e[1;31mMain Menu\e[0m"
echo -e ""
read -p "    Select From Options [1-5 or x] :" Restart
echo -e ""
echo -e "======================================"
sleep 1
clear
case $Restart in
                1)
                clear
                /etc/init.d/cron restart
                /etc/init.d/nginx restart
				systemctl restart xray
				systemctl restart xray@none
				systemctl restart xray@vless
				systemctl restart xray@vnone
                systemctl restart xray@trojanws
                systemctl restart xray@trnone
				systemctl restart xray@vmessgun
				systemctl restart xray@vlessgun
                systemctl restart xray@trojangun
				systemctl restart xray@xtls
				systemctl restart xray@trojan
				systemctl restart trojan-go
				/etc/init.d/ssrmu restart
               echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "          \e[0;32mALL Service Restarted\e[0m         "
                echo -e ""
                echo -e "======================================"
                exit
                ;;
                2)
                clear
                /etc/init.d/nginx restart
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "         \e[0;32mNginx Service Restarted\e[0m      "
                echo -e ""
                echo -e "======================================"
                exit
                ;;
                3)
                clear
				systemctl restart xray
				systemctl restart xray@none
				systemctl restart xray@vless
				systemctl restart xray@vnone
				systemctl restart xray@trojanws
                systemctl restart xray@trnone
				systemctl restart xray@xtls
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "         \e[0;32mXray Service Restart\e[0m         "
                echo -e ""
                echo -e "======================================"
                exit
                ;;
                4)
		clear
		systemctl restart trojan-go
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "      \e[0;32mAll Trojan Service Restart\e[0m      "
                echo -e ""
                echo -e "======================================"
                exit
                ;;
                5)
		clear
                /etc/init.d/ssrmu restart
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "      \e[0;32mShadowsockR Service Restart\e[0m     "
                echo -e ""
                echo -e "======================================"
                exit
                ;;
                x)
                clear
                menu
                ;;
                esac
