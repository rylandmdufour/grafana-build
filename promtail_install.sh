#/bin/bash

apt update
apt install unzip -y

mkdir /opt/promtail
cd /opt/promtail
wget https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip -O promtail.zip
unzip *.zip
rm *.zip
mv prom* promtail
wget https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-local-config.yaml


cat << EOF > /etc/systemd/system/promtail.service 
[Unit]
Description=Promtail
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/promtail/promtail -config.file=/opt/promtail/promtail-local-config.yaml

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable promtail
systemctl start promtail
sleep 5s
systemctl status promtail

#### CLEAN UP ####


