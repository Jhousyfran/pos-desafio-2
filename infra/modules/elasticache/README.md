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
| [aws_elasticache_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cache_config"></a> [cache\_config](#input\_cache\_config) | Lista de caches a serem criados | <pre>list(object({<br/>    name                 = string<br/>    engine               = string<br/>    engine_version       = string<br/>    node_type            = string<br/>    num_cache_nodes      = number<br/>    parameter_group_name = string<br/>    port                 = number<br/>  }))</pre> | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix para nomear os recursos | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Nome do projeto | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | IDs das subnets privadas para o RDS | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags para aplicar aos recursos | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->