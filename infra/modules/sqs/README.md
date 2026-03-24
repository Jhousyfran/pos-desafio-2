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
| [aws_sqs_queue.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix para nomear os recursos | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Nome do projeto | `string` | n/a | yes |
| <a name="input_queues"></a> [queues](#input\_queues) | Lista de filas SQS a serem criadas | <pre>list(object({<br/>    name                      = string<br/>    delay_seconds             = number<br/>    max_message_size          = number<br/>    message_retention_seconds = number<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags para aplicar aos recursos | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->