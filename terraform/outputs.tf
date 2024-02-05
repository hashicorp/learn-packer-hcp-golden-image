# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "loki_ip" {
  value       = aws_instance.loki.public_ip
  description = "Public IP address for the Loki and Grafana instance."
}