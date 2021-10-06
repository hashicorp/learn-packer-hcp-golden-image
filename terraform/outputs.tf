output "loki_ip" {
  value = aws_instance.loki.public_ip
  description = "Public IP address for the Loki and Grafana instance."
}

/*
output "hashicups_east_ip" {
  value = aws_instance.hashicups_east.public_ip
  description = "Public IP address for the HashiCups instance in us-east-2."
}

output "hashicups_west_ip" {
  value = aws_instance.hashicups_west.public_ip
  description = "Public IP address for the HashiCups instance in us-west-2."
}
*/