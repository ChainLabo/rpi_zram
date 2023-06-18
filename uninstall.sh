#! /usr/bin/bash
# rpi_zram unstall

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

#sudo vi /etc/rc.local -c 'normal /zram' -c 'normal dd' -c ':wq'
systemctl stop zram.service
systemctl disable zram.service
rm -rf /etc/systemd/system/zram.service
rm -rf /usr/local/bin/zram.sh
