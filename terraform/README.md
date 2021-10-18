<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | 0.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_aws.west"></a> [aws.west](#provider\_aws.west) | ~> 3.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.igw_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_internet_gateway.igw_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.rtb_public_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.rtb_public_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rta_subnet_public_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_subnet_public_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_egress_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_egress_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.hashicups_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.hashicups_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.loki_grafana_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.loki_grafana_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.promtail_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.promtail_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssh_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssh_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.subnet_public_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnet_public_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc_east](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc.vpc_west](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [hcp_packer_image.loki](https://registry.terraform.io/providers/hashicorp/hcp/0.17.0/docs/data-sources/packer_image) | data source |
| [hcp_packer_iteration.loki](https://registry.terraform.io/providers/hashicorp/hcp/0.17.0/docs/data-sources/packer_iteration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_subnet_east"></a> [cidr\_subnet\_east](#input\_cidr\_subnet\_east) | CIDR block for the subnet | `string` | `"10.1.0.0/24"` | no |
| <a name="input_cidr_subnet_west"></a> [cidr\_subnet\_west](#input\_cidr\_subnet\_west) | CIDR block for the subnet | `string` | `"10.2.0.0/24"` | no |
| <a name="input_cidr_vpc_east"></a> [cidr\_vpc\_east](#input\_cidr\_vpc\_east) | CIDR block for the VPC | `string` | `"10.1.0.0/16"` | no |
| <a name="input_cidr_vpc_west"></a> [cidr\_vpc\_west](#input\_cidr\_vpc\_west) | CIDR block for the VPC | `string` | `"10.2.0.0/16"` | no |
| <a name="input_environment_tag"></a> [environment\_tag](#input\_environment\_tag) | Environment tag | `string` | `"Learn"` | no |
| <a name="input_hcp_bucket_hashicups"></a> [hcp\_bucket\_hashicups](#input\_hcp\_bucket\_hashicups) | HCP Packer bucket name for base golden image | `string` | `"learn-packer-hcp-hashicups-image"` | no |
| <a name="input_hcp_bucket_loki"></a> [hcp\_bucket\_loki](#input\_hcp\_bucket\_loki) | HCP Packer bucket name for loki image | `string` | `"learn-packer-hcp-loki-image"` | no |
| <a name="input_hcp_channel"></a> [hcp\_channel](#input\_hcp\_channel) | HCP Packer channel name | `string` | `"production"` | no |
| <a name="input_region_east"></a> [region\_east](#input\_region\_east) | The default region where Terraform deploys your resources | `string` | `"us-east-2"` | no |
| <a name="input_region_west"></a> [region\_west](#input\_region\_west) | The second region where Terraform deploys your resources | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loki_ip"></a> [loki\_ip](#output\_loki\_ip) | Public IP address for the Loki and Grafana instance. |
<!-- END_TF_DOCS -->