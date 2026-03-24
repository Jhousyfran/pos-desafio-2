<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.eks_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.eks_cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group_rule.eks_cluster_inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [tls_certificate.eks_cluster](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix para nomear os recursos | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Nome do projeto | `string` | n/a | yes |
| <a name="input_public_subnet_1a_id"></a> [public\_subnet\_1a\_id](#input\_public\_subnet\_1a\_id) | ID da sub-rede pública na zona de disponibilidade 1a | `string` | n/a | yes |
| <a name="input_public_subnet_1b_id"></a> [public\_subnet\_1b\_id](#input\_public\_subnet\_1b\_id) | ID da sub-rede pública na zona de disponibilidade 1b | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags para aplicar aos recursos | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_certificate_authority"></a> [eks\_certificate\_authority](#output\_eks\_certificate\_authority) | Dados da autoridade certificadora do cluster EKS |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint do cluster EKS |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Nome do cluster EKS |
| <a name="output_eks_vpc_config"></a> [eks\_vpc\_config](#output\_eks\_vpc\_config) | Configuração VPC do cluster EKS |
| <a name="output_oidc"></a> [oidc](#output\_oidc) | n/a |
<!-- END_TF_DOCS -->