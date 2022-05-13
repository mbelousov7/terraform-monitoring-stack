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
| [kubernetes_secret.config-s3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.thanos_compact](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |
| [null_resource.oc_route](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_path_s3"></a> [config\_path\_s3](#input\_config\_path\_s3) | path to secrets files | `string` | `"/thanos/secrets"` | no |
| <a name="input_config_s3"></a> [config\_s3](#input\_config\_s3) | n/a | `map` | `{}` | no |
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `list` | <pre>[<br>  "--log.level=warn",<br>  "--delete-delay=0"<br>]</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | image path | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | query http port, must not be changed | `number` | `9090` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.2",<br>  "limits_ephemeral_storage": "5Gi",<br>  "limits_memory": "260M",<br>  "requests_cpu": "0.2",<br>  "requests_ephemeral_storage": "5Gi",<br>  "requests_memory": "250M",<br>  "size_limit": "5Gi"<br>}</pre> | no |
| <a name="input_dataDir"></a> [dataDir](#input\_dataDir) | path data dir | `string` | `"/data"` | no |
| <a name="input_expose"></a> [expose](#input\_expose) | expose resource type(ingress for kubernetes or route for openshift) | `string` | `"none"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"thanos-compact"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for postgres | `string` | `"monitoring"` | no |
| <a name="input_nginx_ingress_port"></a> [nginx\_ingress\_port](#input\_nginx\_ingress\_port) | nginx\_ingress\_port | `number` | `8080` | no |
| <a name="input_nginx_ingress_service_name"></a> [nginx\_ingress\_service\_name](#input\_nginx\_ingress\_service\_name) | nginx\_ingress\_service\_name | `string` | `"nginx-ingress"` | no |
| <a name="input_prometheus_replica_label"></a> [prometheus\_replica\_label](#input\_prometheus\_replica\_label) | prometheus replica label name, using for deduplication algorithm | `string` | `"prometheus_replica"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_retention"></a> [retention](#input\_retention) | path data dir | `map` | <pre>{<br>  "resolution_1h": "90d",<br>  "resolution_5m": "30d",<br>  "resolution_raw": "7d"<br>}</pre> | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"None"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
<!-- END_TF_DOCS -->