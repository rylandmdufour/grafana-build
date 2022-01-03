#/bin/bash

apt update

mkdir /opt/mtr_exporter
cd /opt/mtr_exporter

wget https://github.com/rylandmdufour/grafana-build/raw/main/mtr-exporter

cat << EOF > /etc/systemd/system/mtr-exporter.service 
[Unit]
Description=MTR Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/mtr_exporter/mtr-exporter -mtr /usr/bin/mtr -tslogs -schedule "@every 10s" -- -G 1 google.com

[Install]
WantedBy=multi-user.target
EOF

chmod +x /opt/mtr_exporter/mtr-exporter
systemctl daemon-reload
systemctl enable mtr-exporter
systemctl start mtr-exporter
sleep 5s
systemctl status mtr-exporter

#### CLEAN UP ####