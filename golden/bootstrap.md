sudo su -
# apt-get update
# apt-get install -y docker unzip

# Install dependencies
apt install -y docker.io unzip auditd docker-compose

git clone https://github.com/docker/docker-bench-security.git
# cd docker-bench-security
# ./docker-bench-security.sh

# Configure Docker daemon
vi /etc/docker/daemon.json
{
    "icc": false,
    "userns-remap": "default",
    "live-restore": true,
    "userland-proxy": false,
    "no-new-privileges": true,
    "log-driver": "loki",
    "log-opts": {
        "loki-url": "http://18.118.142.233:3100/loki/api/v1/push",
        "loki-batch-size": "400"
    }
}

# Configure auditd
vi /etc/audit/rules.d/audit.rules

# Restart auditd
systemctl restart auditd

# Restart docker
systemctl restart docker

# Enable Content Trust
# echo "DOCKER_CONTENT_TRUST=1" | sudo tee -a /etc/environment

## Set up promtail
mkdir /opt/promtail && cd /opt/promtail
curl -O -L "https://github.com/grafana/loki/releases/download/v1.5.0/promtail-linux-amd64.zip"
unzip "promtail-linux-amd64.zip"
chmod a+x "promtail-linux-amd64"

## Run promtail
./promtail-linux-amd64 -config.file=./promtail.yaml

## Configure Docker with promtail
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
docker plugin disable loki --force
docker plugin upgrade loki grafana/loki-docker-driver:latest --grant-all-permissions
docker plugin enable loki
systemctl restart docker

## HashiCups
wget https://raw.githubusercontent.com/hashicorp/terraform-provider-hashicups/main/docker_compose/conf.json
wget https://raw.githubusercontent.com/hashicorp/terraform-provider-hashicups/main/docker_compose/docker-compose.yml
sudo docker-compose up -d
