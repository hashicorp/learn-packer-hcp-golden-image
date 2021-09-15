output "loki_ip" {
  value = aws_instance.loki.public_ip
}

/*
output "hashicups_east_ip" {
  value = aws_instance.hashicups_east.public_ip
}

output "hashicups_west_ip" {
  value = aws_instance.hashicups_west.public_ip
}
*/