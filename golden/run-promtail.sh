# Run promtail in background
# cd /home/ubuntu
cd /opt/promtail
nohup ./promtail-linux-amd64 -config.file=./promtail.yaml &
