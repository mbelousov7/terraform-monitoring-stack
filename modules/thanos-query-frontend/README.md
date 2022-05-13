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
| [kubernetes_deployment.thanos_query_frontend](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_secret.secret-env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [null_resource.oc_route](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cache_inmemory_config"></a> [cache\_inmemory\_config](#input\_cache\_inmemory\_config) | n/a | `map` | <pre>{<br>  "validity": "6h"<br>}</pre> | no |
| <a name="input_cache_memcached_labels_config"></a> [cache\_memcached\_labels\_config](#input\_cache\_memcached\_labels\_config) | n/a | `map` | <pre>{<br>  "addresses": "thanos-memcached-0.thanos-memcached:11211, thanos-memcached-1.thanos-memcached:11211",<br>  "dns_provider_update_interval": "10s",<br>  "max_async_buffer_size": "100000",<br>  "max_async_concurrency": "20",<br>  "max_get_multi_batch_size": "1000",<br>  "max_get_multi_concurrency": "100",<br>  "max_idle_connections": "100",<br>  "max_item_size": "16MB",<br>  "timeout": "10s"<br>}</pre> | no |
| <a name="input_cache_memcached_query_range_config"></a> [cache\_memcached\_query\_range\_config](#input\_cache\_memcached\_query\_range\_config) | n/a | `map` | <pre>{<br>  "addresses": "thanos-memcached-0.thanos-memcached:11211, thanos-memcached-1.thanos-memcached:11211",<br>  "dns_provider_update_interval": "10s",<br>  "max_async_buffer_size": "100000",<br>  "max_async_concurrency": "20",<br>  "max_get_multi_batch_size": "1000",<br>  "max_get_multi_concurrency": "100",<br>  "max_idle_connections": "100",<br>  "max_item_size": "1MB",<br>  "timeout": "10s"<br>}</pre> | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | cache type  inmemory or memcached | `string` | `"inmemory"` | no |
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | path to sd file | `string` | `"/thanos"` | no |
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `list` | <pre>[<br>  "--log.level=info",<br>  "--log.format=logfmt",<br>  "--query-frontend.compress-responses",<br>  "--query-range.split-interval=12h",<br>  "--query-range.max-retries-per-request=10",<br>  "--query-range.max-query-parallelism=128",<br>  "--query-range.partial-response",<br>  "--labels.response-cache-max-freshness=5m",<br>  "--labels.split-interval=12h",<br>  "--labels.max-retries-per-request=10",<br>  "--labels.max-query-parallelism=256",<br>  "--labels.partial-response",<br>  "--query-frontend.log-queries-longer-than=10s"<br>]</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | image path | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | query http port, must not be changed | `number` | `9090` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.05",<br>  "limits_memory": "250M",<br>  "requests_cpu": "0.05",<br>  "requests_memory": "200M"<br>}</pre> | no |
| <a name="input_env_secret"></a> [env\_secret](#input\_env\_secret) | main pod secret enviroment variables, values provided from outside the module | `map(any)` | `{}` | no |
| <a name="input_expose"></a> [expose](#input\_expose) | expose resource type(ingress for kubernetes or route for openshift) | `string` | `"none"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"thanos-query-frontend"` | no |
| <a name="input_name_thanos_query"></a> [name\_thanos\_query](#input\_name\_thanos\_query) | thanos query name, using for pod\_affinity | `string` | `"thanos-query"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for postgres | `string` | `"monitoring"` | no |
| <a name="input_nginx_ingress_port"></a> [nginx\_ingress\_port](#input\_nginx\_ingress\_port) | nginx\_ingress\_port | `number` | `8080` | no |
| <a name="input_nginx_ingress_service_name"></a> [nginx\_ingress\_service\_name](#input\_nginx\_ingress\_service\_name) | nginx\_ingress\_service\_name | `string` | n/a | yes |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | route suffix | `string` | `"none"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"ClientIP"` | no |
| <a name="input_strategy"></a> [strategy](#input\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
<!-- END_TF_DOCS -->