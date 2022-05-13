locals {



  cache_inmemory_config = {
    max_size_query_range = (regex("[0-9]+", var.container_resources.requests_memory) / 5) * 3
    max_size_labels      = (regex("[0-9]+", var.container_resources.requests_memory) / 5) * 1
    validity             = var.cache_inmemory_config.validity
  }

  thanos_query_config = {
    "config-downstream-tripper.yml" = <<EOF
#idle_conn_timeout - timeout of idle connections (string);
#response_header_timeout - maximum duration to wait for a response header (string);
#tls_handshake_timeout - maximum duration of a TLS handshake (string);
#expect_continue_timeout - Go source code (string);
#max_idle_conns - maximum number of idle connections to all hosts (integer);
#max_idle_conns_per_host - maximum number of idle connections to each host (integer);
max_idle_conns_per_host: 150
#max_conns_per_host - maximum number of connections to each host (integer);
EOF

    "config-cache-query-range.yml" = var.cache_type == "inmemory" ? (<<EOF
type: IN-MEMORY
config:
  max_size: ${local.cache_inmemory_config.max_size_query_range}MB
  validity: ${local.cache_inmemory_config.validity}
EOF
      ) : (
      <<EOF
type: MEMCACHED
config:
  addresses: [${var.cache_memcached_query_range_config.addresses}]
  timeout: ${var.cache_memcached_query_range_config.timeout}
  max_idle_connections: ${var.cache_memcached_query_range_config.max_idle_connections}
  max_async_concurrency: ${var.cache_memcached_query_range_config.max_async_concurrency}
  max_async_buffer_size: ${var.cache_memcached_query_range_config.max_async_buffer_size}
  max_item_size: ${var.cache_memcached_query_range_config.max_item_size}
  max_get_multi_concurrency: ${var.cache_memcached_query_range_config.max_get_multi_concurrency}
  max_get_multi_batch_size: ${var.cache_memcached_query_range_config.max_get_multi_batch_size}
  dns_provider_update_interval: ${var.cache_memcached_query_range_config.dns_provider_update_interval}
EOF
    )

    "config-cache-labels.yml" = var.cache_type == "inmemory" ? (<<EOF
type: IN-MEMORY
config:
  max_size: ${local.cache_inmemory_config.max_size_labels}MB
  validity: ${local.cache_inmemory_config.validity}
EOF
      ) : (
      <<EOF
type: MEMCACHED
config:
  addresses: [${var.cache_memcached_labels_config.addresses}]
  timeout: ${var.cache_memcached_labels_config.timeout}
  max_idle_connections: ${var.cache_memcached_labels_config.max_idle_connections}
  max_async_concurrency: ${var.cache_memcached_labels_config.max_async_concurrency}
  max_async_buffer_size: ${var.cache_memcached_labels_config.max_async_buffer_size}
  max_item_size: ${var.cache_memcached_labels_config.max_item_size}
  max_get_multi_concurrency: ${var.cache_memcached_labels_config.max_get_multi_concurrency}
  max_get_multi_batch_size: ${var.cache_memcached_labels_config.max_get_multi_batch_size}
  dns_provider_update_interval: ${var.cache_memcached_labels_config.dns_provider_update_interval}
EOF
    )
  }
}


resource "kubernetes_config_map" "config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
    labels    = local.labels
  }
  data = local.thanos_query_config
}
