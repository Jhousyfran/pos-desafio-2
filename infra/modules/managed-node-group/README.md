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
| [aws_eks_node_group.eks_mng_nodegroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.eks_managed_nodegroup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_managed_nodegroup_role_attachment_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_managed_nodegroup_role_attachment_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_managed_nodegroup_role_attachment_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Nome do cluster EKS | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix para nomear os recursos | `string` | n/a | yes |
| <a name="input_private_subnet_1a_id"></a> [private\_subnet\_1a\_id](#input\_private\_subnet\_1a\_id) | ID da sub-rede privada na zona de disponibilidade 1a | `string` | n/a | yes |
| <a name="input_private_subnet_1b_id"></a> [private\_subnet\_1b\_id](#input\_private\_subnet\_1b\_id) | ID da sub-rede privada na zona de disponibilidade 1b | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Nome do projeto | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags para aplicar aos recursos | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->