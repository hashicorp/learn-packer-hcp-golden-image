# Set up promtail
cd /opt/promtail
sudo curl -O -L "https://github.com/grafana/loki/releases/download/v2.9.8/promtail-linux-amd64.zip"
sudo unzip "promtail-linux-amd64.zip"
sudo chmod a+x "promtail-linux-amd64"

## Configure Docker with promtail
sudo docker plugin install grafana/loki-docker-driver:2.9.8 --alias loki --grant-all-permissions

# Restart auditd
sudo systemctl restart auditd

# Restart docker
sudo systemctl restart docker
