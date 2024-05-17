sudo su -
apt install -y docker.io unzip

# Install dependencies
curl -O -L "https://github.com/grafana/loki/releases/download/v2.3.0/loki-linux-amd64.zip"
unzip "loki-linux-amd64.zip"
chmod a+x "loki-linux-amd64"

# Create Loki local config
wget https://raw.githubusercontent.com/grafana/loki/master/cmd/loki/loki-local-config.yaml


./loki-linux-amd64 -config.file=loki-local-config.yaml
