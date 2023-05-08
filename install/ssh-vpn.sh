#!/bin/bash
# By key
# ==================================================
#wget https://github.com/${GitUser}/
GitUser="keyjsl"
# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country="MY"
state="Sabah"
locality="Kota Kinabalu"
organization="@keyjsl"
organizationalunit="@keyjsl"
commonname="key"
email="admin@key.xyz"

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "menu" >> .profile

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/vps.conf"
/etc/init.d/nginx restart

apt-get -y update
# setting port ssh
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'
# /etc/ssh/sshd_config
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# install squid for debian 9,10 & ubuntu 20.04
apt -y install squid3
# install squid for debian 11
apt -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

END

# install lolcat
wget https://raw.githubusercontent.com/${GitUser}/v-code/vswss/lolcat.sh &&  chmod +x lolcat.sh && ./lolcat.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/banner/bannerssh.conf"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

#Bannerku menu
wget -O /usr/bin/bannerku https://raw.githubusercontent.com/${GitUser}/v-code/vswss/banner/bannerku && chmod +x /usr/bin/bannerku

#install bbr
wget https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/bbr.sh && chmod +x bbr.sh && ./bbr.sh

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/add-host.sh"
wget -O about "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/about.sh"
wget -O menu "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/menu.sh"
wget -O delete "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/delete-user/delete.sh"
wget -O restart "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/info.sh"
wget -O ram "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/ram.sh"
wget -O clear-log "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/change.sh"
wget -O port-squid "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/change-port/port-squid.sh"
wget -O wbmn "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/webmin.sh"
wget -O update "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/update/update.sh"
wget -O run-update "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/update/run-update.sh"
wget -O message-ssh "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/update/message-ssh.sh"
wget -O xp "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/xp.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/kernel.sh"
wget -O antitorrent "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/more-option/antitorrent.sh"
wget -O cfa "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/cloud/cfa.sh"
wget -O cfd "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/cloud/cfd.sh"
wget -O cfp "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/cloud/cfp.sh"
wget -O swap "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/swapkvm.sh"
wget -O check-sc "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/running.sh"
wget -O ssh "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/menu/ssh.sh"
wget -O autoreboot "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/autoreboot.sh"
wget -O bbr "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/system/bbr.sh"
wget -O port-xray "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/change-port/port-xray.sh"
wget -O panel-domain "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/menu/panel-domain.sh"
wget -O system "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/menu/system.sh"
wget -O themes "https://raw.githubusercontent.com/${GitUser}/v-code/vswss/menu/themes.sh"
chmod +x add-host
chmod +x menu
chmod +x delete
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x ram
chmod +x clear-log
chmod +x change-port
chmod +x restore
chmod +x port-squid
chmod +x wbmn
chmod +x update
chmod +x run-update
chmod +x message-ssh
chmod +x xp
chmod +x kernel-updt
chmod +x antitorrent
chmod +x cfa
chmod +x cfd
chmod +x cfp
chmod +x swap
chmod +x check-sc
chmod +x ssh
chmod +x autoreboot
chmod +x bbr
chmod +x port-xray
chmod +x panel-domain
chmod +x system
chmod +x themes
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
echo "0 0 * * * root delete" >> /etc/crontab
# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/fail2ban restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/ssh-vpn.sh

# finishing
clear
