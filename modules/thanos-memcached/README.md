<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.thanos_memcached](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | n/a | `bool` | `false` | no |
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `list` | `[]` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | image path | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | memcached port | `number` | `11211` | no |
| <a name="input_container_port_metrics"></a> [container\_port\_metrics](#input\_container\_port\_metrics) | memcached metrics port | `number` | `9150` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.2",<br>  "limits_ephemeral_storage": "5Gi",<br>  "limits_memory": "2048M",<br>  "requests_cpu": "0.2",<br>  "requests_ephemeral_storage": "5Gi",<br>  "requests_memory": "1512M"<br>}</pre> | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 15,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"thanos-memcached"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for thanos-memcached | `string` | `"monitoring"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 15,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_account_token_name"></a> [service\_account\_token\_name](#input\_service\_account\_token\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_cluster_ip"></a> [service\_cluster\_ip](#input\_service\_cluster\_ip) | n/a | `string` | `"None"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"None"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
| <a name="output_name"></a> [name](#output\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix |
| <a name="output_replicas"></a> [replicas](#output\_replicas) | replicas number |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix |
<!-- END_TF_DOCS -->