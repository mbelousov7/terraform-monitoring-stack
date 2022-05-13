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
| [kubernetes_deployment.thanos_tools_bucket_web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_secret.config-s3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [null_resource.oc_route](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | path to configs files | `string` | `"/thanos/configs"` | no |
| <a name="input_config_path_s3"></a> [config\_path\_s3](#input\_config\_path\_s3) | path to secrets files | `string` | `"/thanos/secrets"` | no |
| <a name="input_config_s3"></a> [config\_s3](#input\_config\_s3) | n/a | `map` | `{}` | no |
| <a name="input_container_args"></a> [container\_args](#input\_container\_args) | additional container args | `list` | <pre>[<br>  "--log.level=info"<br>]</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | image path | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | query http port, must not be changed | `number` | `9090` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "0.2",<br>  "limits_memory": "260M",<br>  "requests_cpu": "0.2",<br>  "requests_memory": "250M"<br>}</pre> | no |
| <a name="input_expose"></a> [expose](#input\_expose) | expose resource type(ingress for kubernetes or route for openshift) | `string` | `"none"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 10,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"bucket-web"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for postgres | `string` | `"monitoring"` | no |
| <a name="input_nginx_ingress_port"></a> [nginx\_ingress\_port](#input\_nginx\_ingress\_port) | nginx\_ingress\_port | `number` | `8080` | no |
| <a name="input_nginx_ingress_service_name"></a> [nginx\_ingress\_service\_name](#input\_nginx\_ingress\_service\_name) | nginx\_ingress\_service\_name | `string` | `"nginx-ingress"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 3,<br>  "initial_delay_seconds": 5,<br>  "period_seconds": 60,<br>  "timeout_seconds": 5<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | route suffix | `string` | `"none"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"None"` | no |
| <a name="input_strategy"></a> [strategy](#input\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_port"></a> [container\_port](#output\_container\_port) | app port |
<!-- END_TF_DOCS -->