#/bin/bash

apt update

mkdir /opt/pihole_exporter
cd /opt/pihole_exporter

wget https://github.com/rylandmdufour/grafana-build/raw/main/pihole_exporter-linux-amd64
mv pihole* pihole_exporter

cat << EOF > /etc/systemd/system/pihole-exporter.service 
[Unit]
Description=Pihole Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/opt/pihole_exporter/pihole-exporter -pihole_hostname pihole1 -pihole_password pihole

[Install]
WantedBy=multi-user.target
EOF

useradd --no-create-home --shell /bin/false node_exporter
chown -R node_exporter:node_exporter /opt/pihole_exporter

systemctl daemon-reload
systemctl enable pihole-exporter
systemctl start pihole-exporter
systemctl status pihole-exporter

#### CLEAN UP ####