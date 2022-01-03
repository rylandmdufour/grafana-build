#/bin/bash

apt update

mkdir /opt/pihole_exporter
cd /opt/pihole_exporter

wget https://github.com/rylandmdufour/grafana-build/raw/main/pihole_exporter-linux-amd64
mv pihole* pihole_exporter
chmod +x pihole_exporter

cat << EOF > /etc/systemd/system/pihole-exporter.service 
[Unit]
Description=Pihole Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/pihole_exporter/pihole_exporter -pihole_hostname pihole1 -pihole_password pihole

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable pihole-exporter
systemctl start pihole-exporter
sleep 5s
systemctl status pihole-exporter

#### CLEAN UP ####