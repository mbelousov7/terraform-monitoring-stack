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
| [kubernetes_config_map.config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.thanos_query](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_secret.secret-env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.service_sidecars](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [null_resource.oc_route](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | n/a | `bool` | `false` | no |
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | path to sd file | `string` | `"/thanos"` | no |
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `list` | <pre>[<br>  "--log.level=info",<br>  "--query.timeout=1m",<br>  "--query.max-concurrent=24",<br>  "--query.max-concurrent-select=12",<br>  "--query.auto-downsampling",<br>  "--query.partial-response"<br>]</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | image path | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | query http port, must not be changed | `number` | `9090` | no |
| <a name="input_container_port_grpc"></a> [container\_port\_grpc](#input\_container\_port\_grpc) | query grpc port, must not be changed | `number` | `10901` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.2",<br>  "limits_memory": "260M",<br>  "requests_cpu": "0.2",<br>  "requests_memory": "250M"<br>}</pre> | no |
| <a name="input_env_secret"></a> [env\_secret](#input\_env\_secret) | main pod secret enviroment variables, values provided from outside the module | `map(any)` | `{}` | no |
| <a name="input_expose"></a> [expose](#input\_expose) | expose resource type(ingress for kubernetes or route for openshift) | `string` | `"none"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"thanos-query"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for postgres | `string` | `"monitoring"` | no |
| <a name="input_nginx_ingress_port"></a> [nginx\_ingress\_port](#input\_nginx\_ingress\_port) | nginx\_ingress\_port | `number` | `8080` | no |
| <a name="input_nginx_ingress_service_name"></a> [nginx\_ingress\_service\_name](#input\_nginx\_ingress\_service\_name) | nginx\_ingress\_service\_name | `string` | n/a | yes |
| <a name="input_prometheus_replica_label"></a> [prometheus\_replica\_label](#input\_prometheus\_replica\_label) | prometheus replica label name, using for deduplication algorithm | `string` | `"prometheus_replica"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | route suffix | `string` | `"none"` | no |
| <a name="input_sd_data"></a> [sd\_data](#input\_sd\_data) | prometheus.yml config map | `map` | <pre>{<br>  "sd.yml": "- targets:\n  - prometheus-h1-0.prometheus-h1:10091\n  - prometheus-h1-1.prometheus-h1:10091\n"<br>}</pre> | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_account_token_name"></a> [service\_account\_token\_name](#input\_service\_account\_token\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_sidecars"></a> [service\_sidecars](#input\_service\_sidecars) | n/a | `map` | <pre>{<br>  "cluster_ip": "None",<br>  "name": "sidecars",<br>  "selector": {<br>    "module": "prometheus"<br>  },<br>  "session_affinity": "None",<br>  "type": "ClusterIP"<br>}</pre> | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"None"` | no |
| <a name="input_strategy"></a> [strategy](#input\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
<!-- END_TF_DOCS -->