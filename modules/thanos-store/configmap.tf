
/*
locals {
  config_cache_inmemory = {
    "config-cache-index.yml"  = <<EOF
type: IN-MEMORY
config:
  max_size: ${var.cache_inmemory_config.index_max_size}
  validity: ${var.cache_inmemory_config.validity}
EOF
    "config-cache-bucket.yml" = <<EOF
type: IN-MEMORY
config:
  max_size: ${var.cache_inmemory_config.bucket_max_size}
  validity: ${var.cache_inmemory_config.validity}
chunk_subrange_size: ${var.cache_bucket_config.chunk_subrange_size}
max_chunks_get_range_requests: ${var.cache_bucket_config.max_chunks_get_range_requests}
chunk_object_attrs_ttl: ${var.cache_bucket_config.chunk_object_attrs_ttl}
chunk_subrange_ttl: ${var.cache_bucket_config.chunk_subrange_ttl}
blocks_iter_ttl: ${var.cache_bucket_config.blocks_iter_ttl}
metafile_exists_ttl: ${var.cache_bucket_config.metafile_exists_ttl}
metafile_doesnt_exist_ttl: ${var.cache_bucket_config.metafile_doesnt_exist_ttl}
metafile_content_ttl: ${var.cache_bucket_config.metafile_content_ttl}
metafile_max_size: ${var.cache_bucket_config.metafile_max_size}
EOF
  }

  config_cache_memcached = {
    "config-cache-index.yml"  = <<EOF
type: MEMCACHED
config:
  addresses: [${var.cache_memcached_config.addresses}]
  timeout: ${var.cache_memcached_config.timeout}
  max_idle_connections: ${var.cache_memcached_config.max_idle_connections}
  max_async_concurrency: ${var.cache_memcached_config.max_async_concurrency}
  max_async_buffer_size: ${var.cache_memcached_config.max_async_buffer_size}
  max_item_size: ${var.cache_memcached_config.max_item_size}
  max_get_multi_concurrency: ${var.cache_memcached_config.max_get_multi_concurrency}
  max_get_multi_batch_size: ${var.cache_memcached_config.max_get_multi_batch_size}
  dns_provider_update_interval: ${var.cache_memcached_config.dns_provider_update_interval}
EOF
    "config-cache-bucket.yml" = <<EOF
type: MEMCACHED
config:
  addresses: [${var.cache_memcached_config.addresses}]
  timeout: ${var.cache_memcached_config.timeout}
  max_idle_connections: ${var.cache_memcached_config.max_idle_connections}
  max_async_concurrency: ${var.cache_memcached_config.max_async_concurrency}
  max_async_buffer_size: ${var.cache_memcached_config.max_async_buffer_size}
  max_item_size: ${var.cache_memcached_config.max_item_size}
  max_get_multi_concurrency: ${var.cache_memcached_config.max_get_multi_concurrency}
  max_get_multi_batch_size: ${var.cache_memcached_config.max_get_multi_batch_size}
  dns_provider_update_interval: ${var.cache_memcached_config.dns_provider_update_interval}
chunk_subrange_size: ${var.cache_bucket_config.chunk_subrange_size}
max_chunks_get_range_requests: ${var.cache_bucket_config.max_chunks_get_range_requests}
chunk_object_attrs_ttl: ${var.cache_bucket_config.chunk_object_attrs_ttl}
chunk_subrange_ttl: ${var.cache_bucket_config.chunk_subrange_ttl}
blocks_iter_ttl: ${var.cache_bucket_config.blocks_iter_ttl}
metafile_exists_ttl: ${var.cache_bucket_config.metafile_exists_ttl}
metafile_doesnt_exist_ttl: ${var.cache_bucket_config.metafile_doesnt_exist_ttl}
metafile_content_ttl: ${var.cache_bucket_config.metafile_content_ttl}
metafile_max_size: ${var.cache_bucket_config.metafile_max_size}
EOF
  }
}
*/


resource "kubernetes_config_map" "config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
    labels    = local.labels
  }
  //data = var.cache_type == "inmemory" ? local.config_cache_inmemory : local.config_cache_memcached
  data = {
    "config-cache-index.yml" = var.cache_type == "inmemory" ? (<<EOF
type: IN-MEMORY
config:
  max_size: ${var.cache_inmemory_config.index_max_size}
  validity: ${var.cache_inmemory_config.validity}
EOF
      ) : (
      <<EOF
type: MEMCACHED
config:
  addresses: [${var.cache_memcached_index_config.addresses}]
  timeout: ${var.cache_memcached_index_config.timeout}
  max_idle_connections: ${var.cache_memcached_index_config.max_idle_connections}
  max_async_concurrency: ${var.cache_memcached_index_config.max_async_concurrency}
  max_async_buffer_size: ${var.cache_memcached_index_config.max_async_buffer_size}
  max_item_size: ${var.cache_memcached_index_config.max_item_size}
  max_get_multi_concurrency: ${var.cache_memcached_index_config.max_get_multi_concurrency}
  max_get_multi_batch_size: ${var.cache_memcached_index_config.max_get_multi_batch_size}
  dns_provider_update_interval: ${var.cache_memcached_index_config.dns_provider_update_interval}
EOF
    )
    "config-cache-bucket.yml" = var.cache_type == "inmemory" ? (<<EOF
type: IN-MEMORY
config:
  max_size: ${var.cache_inmemory_config.bucket_max_size}
  validity: ${var.cache_inmemory_config.validity}
chunk_subrange_size: ${var.cache_bucket_config.chunk_subrange_size}
max_chunks_get_range_requests: ${var.cache_bucket_config.max_chunks_get_range_requests}
chunk_object_attrs_ttl: ${var.cache_bucket_config.chunk_object_attrs_ttl}
chunk_subrange_ttl: ${var.cache_bucket_config.chunk_subrange_ttl}
blocks_iter_ttl: ${var.cache_bucket_config.blocks_iter_ttl}
metafile_exists_ttl: ${var.cache_bucket_config.metafile_exists_ttl}
metafile_doesnt_exist_ttl: ${var.cache_bucket_config.metafile_doesnt_exist_ttl}
metafile_content_ttl: ${var.cache_bucket_config.metafile_content_ttl}
metafile_max_size: ${var.cache_bucket_config.metafile_max_size}
EOF
      ) : (
      <<EOF
type: MEMCACHED
config:
  addresses: [${var.cache_memcached_bucket_config.addresses}]
  timeout: ${var.cache_memcached_bucket_config.timeout}
  max_idle_connections: ${var.cache_memcached_bucket_config.max_idle_connections}
  max_async_concurrency: ${var.cache_memcached_bucket_config.max_async_concurrency}
  max_async_buffer_size: ${var.cache_memcached_bucket_config.max_async_buffer_size}
  max_item_size: ${var.cache_memcached_bucket_config.max_item_size}
  max_get_multi_concurrency: ${var.cache_memcached_bucket_config.max_get_multi_concurrency}
  max_get_multi_batch_size: ${var.cache_memcached_bucket_config.max_get_multi_batch_size}
  dns_provider_update_interval: ${var.cache_memcached_bucket_config.dns_provider_update_interval}
chunk_subrange_size: ${var.cache_bucket_config.chunk_subrange_size}
max_chunks_get_range_requests: ${var.cache_bucket_config.max_chunks_get_range_requests}
chunk_object_attrs_ttl: ${var.cache_bucket_config.chunk_object_attrs_ttl}
chunk_subrange_ttl: ${var.cache_bucket_config.chunk_subrange_ttl}
blocks_iter_ttl: ${var.cache_bucket_config.blocks_iter_ttl}
metafile_exists_ttl: ${var.cache_bucket_config.metafile_exists_ttl}
metafile_doesnt_exist_ttl: ${var.cache_bucket_config.metafile_doesnt_exist_ttl}
metafile_content_ttl: ${var.cache_bucket_config.metafile_content_ttl}
metafile_max_size: ${var.cache_bucket_config.metafile_max_size}
EOF
    )
  }

}
