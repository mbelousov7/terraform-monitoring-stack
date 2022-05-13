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
| [kubernetes_secret.env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `list` | `[]` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | postgres image | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | postgres port, must not be changed | `number` | `5432` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "140m",<br>  "limits_memory": "180Mi",<br>  "requests_cpu": "110m",<br>  "requests_memory": "150Mi"<br>}</pre> | no |
| <a name="input_env_secret"></a> [env\_secret](#input\_env\_secret) | main pod secret enviroment variables, values provided from outside the module | `map(any)` | <pre>{<br>  "POSTGRES_DB": "database",<br>  "POSTGRES_PASSWORD": "password",<br>  "POSTGRES_USER": "admin"<br>}</pre> | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 10,<br>  "initial_delay_seconds": 60,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"postgres"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for postgres | `string` | `"monitoring"` | no |
| <a name="input_pod_management_policy"></a> [pod\_management\_policy](#input\_pod\_management\_policy) | n/a | `string` | `"OrderedReady"` | no |
| <a name="input_read_only_root_filesystem"></a> [read\_only\_root\_filesystem](#input\_read\_only\_root\_filesystem) | n/a | `bool` | `true` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 10,<br>  "initial_delay_seconds": 15,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"ClientIP"` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | app stateful\_set name |
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
<!-- END_TF_DOCS -->