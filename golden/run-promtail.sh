# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Run promtail in background
cd /opt/promtail
nohup ./promtail-linux-amd64 -config.file=./promtail.yaml &
