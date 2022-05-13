<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role.sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_config_map.config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.config-map-list](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rules](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.targets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_ingress.nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_role_binding.sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_secret.s3-config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.service-sidecar](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service_account.sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_stateful_set.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |
| [null_resource.oc_route](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | n/a | `bool` | `false` | no |
| <a name="input_blockDuration"></a> [blockDuration](#input\_blockDuration) | n/a | `string` | `"2h"` | no |
| <a name="input_configPath"></a> [configPath](#input\_configPath) | path to configs folder | `string` | `"/etc/prometheus/config"` | no |
| <a name="input_config_data"></a> [config\_data](#input\_config\_data) | prometheus.yml config map | `map` | <pre>{<br>  "prometheus.yml": "global:\n  scrape_interval: 1m\n  scrape_timeout: 30s\n"<br>}</pre> | no |
| <a name="input_config_maps_list"></a> [config\_maps\_list](#input\_config\_maps\_list) | list config maps and volumes | <pre>list(object({<br>    map_name = string<br>    map_path = string<br>    map_data = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `map` | <pre>{<br>  "log_level": "warn"<br>}</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | path to prometheus image | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `number` | `9090` | no |
| <a name="input_container_port_grpc"></a> [container\_port\_grpc](#input\_container\_port\_grpc) | query grpc port, must not be changed | `number` | `10901` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "300m",<br>  "limits_ephemeral_storage": "5Gi",<br>  "limits_memory": "500Mi",<br>  "requests_cpu": "200m",<br>  "requests_ephemeral_storage": "5Gi",<br>  "requests_memory": "400Mi",<br>  "size_limit": "5Gi"<br>}</pre> | no |
| <a name="input_dataPath"></a> [dataPath](#input\_dataPath) | path to data folder | `string` | `"/data"` | no |
| <a name="input_dataVolume"></a> [dataVolume](#input\_dataVolume) | n/a | `map` | <pre>{<br>  "empty_dir": {},<br>  "name": "storage-volume"<br>}</pre> | no |
| <a name="input_expose"></a> [expose](#input\_expose) | expose resource type(ingress for kubernetes or route for openshift) | `string` | `"none"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 15,<br>  "period_seconds": 60,<br>  "timeout_seconds": 30<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"prometheus"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for prometheus | `string` | `"monitoring"` | no |
| <a name="input_nginx_ingress_port"></a> [nginx\_ingress\_port](#input\_nginx\_ingress\_port) | nginx\_ingress\_port | `number` | `8080` | no |
| <a name="input_nginx_ingress_service_name"></a> [nginx\_ingress\_service\_name](#input\_nginx\_ingress\_service\_name) | nginx\_ingress\_service\_name | `string` | n/a | yes |
| <a name="input_pod_management_policy"></a> [pod\_management\_policy](#input\_pod\_management\_policy) | n/a | `string` | `"OrderedReady"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 60,<br>  "timeout_seconds": 30<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_retentionSize"></a> [retentionSize](#input\_retentionSize) | n/a | `string` | `"30GB"` | no |
| <a name="input_retentionTime"></a> [retentionTime](#input\_retentionTime) | n/a | `string` | `"7d"` | no |
| <a name="input_role_binding"></a> [role\_binding](#input\_role\_binding) | flag is it nessesary to create role | `bool` | `false` | no |
| <a name="input_role_create"></a> [role\_create](#input\_role\_create) | flag is it nessesary to create role | `bool` | `false` | no |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | route suffix | `string` | `"none"` | no |
| <a name="input_rulesPath"></a> [rulesPath](#input\_rulesPath) | path to rules folder | `string` | `"/etc/prometheus/rules"` | no |
| <a name="input_rules_data"></a> [rules\_data](#input\_rules\_data) | alert rules config map | `map` | <pre>{<br>  "rules.yml": "\n"<br>}</pre> | no |
| <a name="input_sa_create"></a> [sa\_create](#input\_sa\_create) | flag is it nessesary to create sa | `bool` | `false` | no |
| <a name="input_secret_maps_list"></a> [secret\_maps\_list](#input\_secret\_maps\_list) | list secret maps and volumes | <pre>list(object({<br>    map_name = string<br>    map_path = string<br>    map_data = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_account_token_name"></a> [service\_account\_token\_name](#input\_service\_account\_token\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"ClientIP"` | no |
| <a name="input_targets_folder"></a> [targets\_folder](#input\_targets\_folder) | folder path to  .json's | `string` | `"./"` | no |
| <a name="input_targets_list"></a> [targets\_list](#input\_targets\_list) | targets names lists for prometheus | `list(string)` | `[]` | no |
| <a name="input_thanos_sidecar_config"></a> [thanos\_sidecar\_config](#input\_thanos\_sidecar\_config) | n/a | `list` | `[]` | no |
| <a name="input_thanos_sidecar_image_pull_policy"></a> [thanos\_sidecar\_image\_pull\_policy](#input\_thanos\_sidecar\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | app service name |
<!-- END_TF_DOCS -->