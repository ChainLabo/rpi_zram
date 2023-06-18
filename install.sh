#! /usr/bin/bash
# rpi_zram install

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

DOWNLOAD_URL="https://raw.githubusercontent.com/ChainLabo/rpi_zram/master/zram.sh"

#Download the script and copy to /usr/bin/ folder
wget -O /usr/local/bin/zram.sh $DOWNLOAD_URL

#make file executable
chmod +x /usr/local/bin/zram.sh

#add line before exit 0
#sudo vi /etc/rc.local -c 'normal GO/usr/bin/zram.sh &' -c ':wq'

#add systemd service

tee /etc/systemd/system/zram.service <<-'EOF'
[Unit]
Description=zram Service
;After=network-online.target
;Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Type=simple
ExecStart=/usr/local/bin/zram.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable zram.service
