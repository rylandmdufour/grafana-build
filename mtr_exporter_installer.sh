#/bin/bash

apt update

mkdir /opt/mtr
cd /opt/mtr

### need to get mtr-exporter file ####
######wget https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip -O promtail.zip

cat << EOF > /etc/systemd/system/mtr-exporter.service 
[Unit]
Description=MTR Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/opt/mtr_exporter/mtr-exporter -tslogs -schedule "@every 10s" -- -G 1 google.com

[Install]
WantedBy=multi-user.target
EOF

useradd --no-create-home --shell /bin/false node_exporter
chown -R node_exporter:node_exporter /opt/promtail
#chown promtail:promtail /etc/promtail
systemctl daemon-reload
systemctl enable mtr-exporter
systemctl start mtr-exporter
systemctl status mtr-exporter

#### CLEAN UP ####


