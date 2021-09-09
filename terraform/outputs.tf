// output "base_ip" {
//   value = aws_instance.base.public_ip
// }

output "loki_ip" {
  value = aws_instance.loki.public_ip
}

output "hashicups_ip" {
  value = aws_instance.hashicups.public_ip
}