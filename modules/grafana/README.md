<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_openshift_routes"></a> [openshift\_routes](#module\_openshift\_routes) | ../openshift-route | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.config-map-list](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.dashboards](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.fluentbit](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.thanos_query_frontend_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_ingress.nginx-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_secret.grafana-secret-env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.ssl-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.grafana](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_maps_list"></a> [config\_maps\_list](#input\_config\_maps\_list) | list config maps and volumes | <pre>list(object({<br>    map_name = string<br>    map_path = string<br>    map_data = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | path to grafana image | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | n/a | `number` | `3000` | no |
| <a name="input_container_resources"></a> [container\_resources](#input\_container\_resources) | n/a | `map` | <pre>{<br>  "limits_cpu": "150m",<br>  "limits_memory": "250Mi",<br>  "requests_cpu": "100m",<br>  "requests_memory": "150Mi"<br>}</pre> | no |
| <a name="input_dashboards_folder"></a> [dashboards\_folder](#input\_dashboards\_folder) | folder path dashboards .json's | `string` | `"./dashboards"` | no |
| <a name="input_dashboards_map"></a> [dashboards\_map](#input\_dashboards\_map) | dashboards map | `map` | <pre>{<br>  "system-template-jmx": {<br>    "folder": "main"<br>  },<br>  "system-template-os": {<br>    "folder": "main"<br>  }<br>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | main pod enviroment variables, values provided from outside the module | `map(any)` | <pre>{<br>  "GF_DATABASE_HOST": "grafana-db",<br>  "GF_DATABASE_NAME": "grafana",<br>  "GF_DATABASE_TYPE": "sqlite3",<br>  "GF_PATHS_CONFIG": "/etc/grafana/grafana.ini",<br>  "GF_PATHS_PROVISIONING": "/etc/grafana/provisioning"<br>}</pre> | no |
| <a name="input_env_secret"></a> [env\_secret](#input\_env\_secret) | main pod secret enviroment variables, values provided from outside the module | `map(any)` | <pre>{<br>  "GF_DATABASE_PASSWORD": "password",<br>  "GF_DATABASE_USER": "admin",<br>  "GF_SECURITY_ADMIN_PASSWORD": "password",<br>  "GF_SECURITY_ADMIN_USER": "admin"<br>}</pre> | no |
| <a name="input_expose"></a> [expose](#input\_expose) | expose resource type(ingress for kubernetes or route for openshift) | `string` | `"none"` | no |
| <a name="input_fluentbit_config"></a> [fluentbit\_config](#input\_fluentbit\_config) | n/a | `map` | <pre>{<br>  "container_resources": {<br>    "limits_cpu": "10m",<br>    "limits_memory": "20M",<br>    "requests_cpu": "10m",<br>    "requests_memory": "20M"<br>  },<br>  "name": "fluentbit"<br>}</pre> | no |
| <a name="input_fluentbit_config_output"></a> [fluentbit\_config\_output](#input\_fluentbit\_config\_output) | FluentBit config for output host, port and app id | <pre>object({<br>    host   = string<br>    port   = string<br>    app_id = string<br>  })</pre> | n/a | yes |
| <a name="input_fluentbit_container_image"></a> [fluentbit\_container\_image](#input\_fluentbit\_container\_image) | path to fluentbit image | `string` | n/a | yes |
| <a name="input_geo_route"></a> [geo\_route](#input\_geo\_route) | Enable geo route | `bool` | `false` | no |
| <a name="input_geo_route_suffix"></a> [geo\_route\_suffix](#input\_geo\_route\_suffix) | Geo route suffix | `string` | `"none"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"Always"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | additional kubernetes labels, values provided from outside the module | `map(string)` | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 5,<br>  "initial_delay_seconds": 60,<br>  "period_seconds": 60,<br>  "timeout_seconds": 15<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix | `string` | `"grafana"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | kubernetes namespace for grafana | `string` | `"monitoring"` | no |
| <a name="input_nginx_ingress_port"></a> [nginx\_ingress\_port](#input\_nginx\_ingress\_port) | nginx\_ingress\_port | `number` | `8080` | no |
| <a name="input_nginx_ingress_service_name"></a> [nginx\_ingress\_service\_name](#input\_nginx\_ingress\_service\_name) | nginx\_ingress\_service\_name | `string` | n/a | yes |
| <a name="input_pod_management_policy"></a> [pod\_management\_policy](#input\_pod\_management\_policy) | n/a | `string` | `"OrderedReady"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | n/a | `map` | <pre>{<br>  "failure_threshold": 5,<br>  "initial_delay_seconds": 60,<br>  "period_seconds": 60,<br>  "timeout_seconds": 15<br>}</pre> | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | replicas count | `number` | `1` | no |
| <a name="input_route_suffix"></a> [route\_suffix](#input\_route\_suffix) | route suffix | `string` | `"none"` | no |
| <a name="input_secret_maps_list"></a> [secret\_maps\_list](#input\_secret\_maps\_list) | list secret maps and volumes | <pre>list(object({<br>    map_name = string<br>    map_path = string<br>    map_data = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | n/a | `string` | `"ClusterIP"` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | n/a | `string` | `"ClientIP"` | no |
| <a name="input_ssl_data"></a> [ssl\_data](#input\_ssl\_data) | ssl cert and key | `map` | `{}` | no |
| <a name="input_thanos_query_frontend"></a> [thanos\_query\_frontend](#input\_thanos\_query\_frontend) | n/a | `string` | `"false"` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | n/a | `string` | `"RollingUpdate"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | app service name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | app service port |
<!-- END_TF_DOCS -->