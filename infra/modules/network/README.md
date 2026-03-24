<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.eks_ngw_eip_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.eks_ngw_eip_1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.eks_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.eks_nat_gateway_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.eks_nat_gateway_1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.eks_private-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.eks_private-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.eks_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.eks_private_1a_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.eks_private_1b_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.eks_public_1a_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.eks_public_1b_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.eks_subnet_private_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.eks_subnet_private_1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.eks_subnet_public_1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.eks_subnet_public_1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Bloco CIDR para a VPC | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix para nomear os recursos | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Nome do projeto | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags para aplicar aos recursos | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_subnet_private_1a_id"></a> [eks\_subnet\_private\_1a\_id](#output\_eks\_subnet\_private\_1a\_id) | ID da sub-rede privada 1a para EKS |
| <a name="output_eks_subnet_private_1b_id"></a> [eks\_subnet\_private\_1b\_id](#output\_eks\_subnet\_private\_1b\_id) | ID da sub-rede privada 1b para EKS |
| <a name="output_eks_subnet_public_1a_id"></a> [eks\_subnet\_public\_1a\_id](#output\_eks\_subnet\_public\_1a\_id) | ID da sub-rede pública 1a para EKS |
| <a name="output_eks_subnet_public_1b_id"></a> [eks\_subnet\_public\_1b\_id](#output\_eks\_subnet\_public\_1b\_id) | ID da sub-rede pública 1b para EKS |
<!-- END_TF_DOCS -->