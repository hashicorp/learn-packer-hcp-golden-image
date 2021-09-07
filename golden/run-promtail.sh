# Run promtail in background
cd /home/ubuntu
nohup ./promtail-linux-amd64 -config.file=./promtail.yaml &
