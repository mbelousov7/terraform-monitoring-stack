<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.oc_route](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_route_name"></a> [route\_name](#input\_route\_name) | Route name to create route, will be used in hostname. | `string` | n/a | yes |
| <a name="input_route_namespace"></a> [route\_namespace](#input\_route\_namespace) | Namespace to create route in. | `string` | n/a | yes |
| <a name="input_route_prefix"></a> [route\_prefix](#input\_route\_prefix) | Route prefix for route, will be used in hostname. Route name will be sued if unset | `string` | `null` | no |
| <a name="input_route_service_name"></a> [route\_service\_name](#input\_route\_service\_name) | Service name to forward route. | `string` | n/a | yes |
| <a name="input_route_service_port"></a> [route\_service\_port](#input\_route\_service\_port) | Service port to forward route. | `string` | n/a | yes |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | Route suffix for route, will be used in hostname. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_hostname"></a> [route\_hostname](#output\_route\_hostname) | Route hostname |
<!-- END_TF_DOCS -->