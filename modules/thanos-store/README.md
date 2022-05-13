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
| [kubernetes_config_map.config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_secret.config-s3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.service-headless](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.thanos_store](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | n/a | `bool` | `false` | no |
| <a name="input_cache_bucket_config"></a> [cache\_bucket\_config](#input\_cache\_bucket\_config) | n/a | `map` | <pre>{<br>  "blocks_iter_ttl": "5m",<br>  "chunk_object_attrs_ttl": "24h",<br>  "chunk_pool_size": "2GB",<br>  "chunk_subrange_size": "16000",<br>  "chunk_subrange_ttl": "24h",<br>  "max_chunks_get_range_requests": "3",<br>  "metafile_content_ttl": "24h",<br>  "metafile_doesnt_exist_ttl": "15m",<br>  "metafile_exists_ttl": "2h",<br>  "metafile_max_size": "16MiB"<br>}</pre> | no |
| <a name="input_cache_inmemory_config"></a> [cache\_inmemory\_config](#input\_cache\_inmemory\_config) | n/a | `map` | <pre>{<br>  "bucket_max_size": "1024MB",<br>  "index_max_size": "1024MB",<br>  "validity": "6h"<br>}</pre> | no |
| <a name="input_cache_memcached_bucket_config"></a> [cache\_memcached\_bucket\_config](#input\_cache\_memcached\_bucket\_config) | n/a | `map` | <pre>{<br>  "addresses": "thanos-memcached-0.thanos-memcached:11211, thanos-memcached-1.thanos-memcached:11211",<br>  "dns_provider_update_interval": "10s",<br>  "max_async_buffer_size": "100000",<br>  "max_async_concurrency": "20",<br>  "max_get_multi_batch_size": "1000",<br>  "max_get_multi_concurrency": "100",<br>  "max_idle_connections": "100",<br>  "max_item_size": "16MB",<br>  "timeout": "10s"<br>}</pre> | no |
| <a name="input_cache_memcached_index_config"></a> [cache\_memcached\_index\_config](#input\_cache\_memcached\_index\_config) | n/a | `map` | <pre>{<br>  "addresses": "thanos-memcached-0.thanos-memcached:11211, thanos-memcached-1.thanos-memcached:11211",<br>  "dns_provider_update_interval": "10s",<br>  "max_async_buffer_size": "100000",<br>  "max_async_concurrency": "20",<br>  "max_get_multi_batch_size": "1000",<br>  "max_get_multi_concurrency": "100",<br>  "max_idle_connections": "100",<br>  "max_item_size": "1MB",<br>  "timeout": "10s"<br>}</pre> | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | cache type  inmemory or memcached | `string` | `"inmemory"` | no |
| <a name="input_cache_type_bucket"></a> [cache\_type\_bucket](#input\_cache\_type\_bucket) | cache type  inmemory or memcached | `string` | `"inmemory"` | no |
| <a name="input_cache_type_index"></a> [cache\_type\_index](#input\_cache\_type\_index) | cache type  inmemory or memcached | `string` | `"inmemory"` | no |
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | path to configs files | `string` | `"/thanos/configs"` | no |
| <a name="input_config_path_s3"></a> [config\_path\_s3](#input\_config\_path\_s3) | path to secrets files | `string` | `"/thanos/secrets"` | no |
| <a name="input_config_s3"></a> [config\_s3](#input\_config\_s3) | n/a | `map` | `{}` | no |
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `list` | <pre>[<br>  "--log.level=info"<br>]</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | image path | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | query http port, must not be changed | `number` | `9090` | no |
| <a name="input_container_port_grpc"></a> [container\_port\_grpc](#input\_container\_port\_grpc) | query grpc port, must not be changed | `number` | `10901` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.2",<br>  "limits_ephemeral_storage": "5Gi",<br>  "limits_memory": "260M",<br>  "requests_cpu": "0.2",<br>  "requests_ephemeral_storage": "5Gi",<br>  "requests_memory": "250M",<br>  "size_limit": "5Gi"<br>}</pre> | no |
| <a name="input_dataDir"></a> [dataDir](#input\_dataDir) | path data dir | `string` | `"/data"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 30,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"thanos-store"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for postgres | `string` | `"monitoring"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 30,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_account_token_name"></a> [service\_account\_token\_name](#input\_service\_account\_token\_name) | n/a | `string` | `"default"` | no |
| <a name="input_service_cluster_ip"></a> [service\_cluster\_ip](#input\_service\_cluster\_ip) | n/a | `string` | `"None"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"None"` | no |
| <a name="input_strategy"></a> [strategy](#input\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
| <a name="output_container_port_grpc"></a> [container\_port\_grpc](#output\_container\_port\_grpc) | app port |
| <a name="output_name"></a> [name](#output\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix |
| <a name="output_replicas"></a> [replicas](#output\_replicas) | replicas number |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix |
| <a name="output_service_name_headless"></a> [service\_name\_headless](#output\_service\_name\_headless) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix |
<!-- END_TF_DOCS -->