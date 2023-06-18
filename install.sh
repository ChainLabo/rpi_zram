#! /usr/bin/bash
# rpi_zram install
DOWNLOAD_URL="https://raw.githubusercontent.com/ChainLabo/rpi_zram/master/zram.sh"

#Download the script and copy to /usr/bin/ folder
sudo wget -O /usr/local/bin/zram.sh $DOWNLOAD_URL

#make file executable
sudo chmod +x /usr/local/bin/zram.sh

#add line before exit 0
#sudo vi /etc/rc.local -c 'normal GO/usr/bin/zram.sh &' -c ':wq'

#add systemd service

sudo tee /etc/systemd/system/zram.service <<-'EOF'
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

sudo systemctl daemon-reload
sudo systemctl enable zram.service
