output "loki_ip" {
  description = "Public IP address for the Loki and Grafana instance."
  value       = aws_instance.loki.public_ip
}

output "grafana_url" {
  description = "Public URL of the Grafana UI."
  value       = "http://${aws_instance.loki.public_ip}:3000"
}

output "loki_url" {
  description = "Public URL of the Loki data source."
  value       = "http://${aws_instance.loki.public_ip}:3100"
}

output "hashicups_east_ip" {
  value       = aws_instance.hashicups_east.public_ip
  description = "Public IP address for the HashiCups instance in us-east-2."
}

output "hashicups_west_ip" {
  value       = aws_instance.hashicups_west.public_ip
  description = "Public IP address for the HashiCups instance in us-west-2."
}

output "hashicups_east_url" {
  value       = "http://${aws_instance.hashicups_east.public_ip}:19090"
  description = "Public URL address for the HashiCups instance in us-east-2."
}

output "hashicups_west_url" {
  value       = "http://${aws_instance.hashicups_west.public_ip}:19090"
  description = "Public IP address for the HashiCups instance in us-west-2."
}
