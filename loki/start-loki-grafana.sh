#!/bin/bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


# Start Loki in background
cd /home/ubuntu
nohup ./loki-linux-amd64 -config.file=loki-local-config.yaml &

# Start Grafana
docker run -d -p 3000:3000 grafana/grafana
