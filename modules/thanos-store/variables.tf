variable "namespace" {
  description = "kubernetes namespace for postgres"
  type        = string
  default     = "monitoring"
}

variable "name" {
  description = "application name, using as deoloyment,serivce names, also in lables, als as configmap and secret prefix"
  type        = string
  default     = "thanos-store"
}

variable "labels" {
  description = "additional kubernetes labels, values provided from outside the module"
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "replicas count"
  type        = number
  default     = 1
}

variable "strategy" {
  type    = string
  default = "RollingUpdate" #"Recreate"
}

variable "container_image" {
  description = "image path"
  type        = string
  #  default     = ""
}

variable "image_pull_policy" {
  type    = string
  default = "Always" #"IfNotPresent"#
}


variable "container_port" {
  description = "query http port, must not be changed"
  type        = number
  default     = 9090
}

variable "container_port_grpc" {
  description = "query grpc port, must not be changed"
  type        = number
  default     = 10901
}

variable "container_resources" {
  default = {
    requests_cpu               = "0.2"
    limits_cpu                 = "0.2"
    requests_memory            = "250M"
    limits_memory              = "260M"
    size_limit                 = "5Gi"
    requests_ephemeral_storage = "5Gi"
    limits_ephemeral_storage   = "5Gi"
  }
}

variable "readiness_probe" {
  default = {
    initial_delay_seconds = 5
    timeout_seconds       = 5
    period_seconds        = 30
    failure_threshold     = 3
  }
}

variable "liveness_probe" {
  default = {
    initial_delay_seconds = 10
    timeout_seconds       = 5
    period_seconds        = 30
    failure_threshold     = 3
  }
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "service_cluster_ip" {
  type    = string
  default = "None"
}

variable "session_affinity" {
  type    = string
  default = "None"
  #default     = "ClientIP"
}

variable "container_args" {
  description = "additional container args"
  default = [
    "--log.level=info",
  ]
}

variable "dataDir" {
  description = "path data dir"
  type        = string
  default     = "/data"
}

variable "config_path" {
  description = "path to configs files"
  type        = string
  default     = "/thanos/configs"
}

variable "cache_type" {
  description = "cache type  inmemory or memcached"
  type        = string
  default     = "inmemory"
}

variable "cache_type_index" {
  description = "cache type  inmemory or memcached"
  type        = string
  default     = "inmemory"
}

variable "cache_type_bucket" {
  description = "cache type  inmemory or memcached"
  type        = string
  default     = "inmemory"
}


variable "cache_bucket_config" {
  default = {
    chunk_pool_size               = "2GB"
    chunk_subrange_size           = "16000"
    max_chunks_get_range_requests = "3"
    chunk_object_attrs_ttl        = "24h"
    chunk_subrange_ttl            = "24h"
    blocks_iter_ttl               = "5m"
    metafile_exists_ttl           = "2h"
    metafile_doesnt_exist_ttl     = "15m"
    metafile_content_ttl          = "24h"
    metafile_max_size             = "16MiB"
  }
}


variable "cache_inmemory_config" {
  default = {
    index_max_size  = "1024MB"
    bucket_max_size = "1024MB"
    validity        = "6h"
  }
}

variable "cache_memcached_index_config" {
  default = {
    addresses                    = "thanos-memcached-0.thanos-memcached:11211, thanos-memcached-1.thanos-memcached:11211"
    timeout                      = "10s"
    max_idle_connections         = "100"
    max_async_concurrency        = "20"
    max_async_buffer_size        = "100000"
    max_item_size                = "1MB"
    max_get_multi_concurrency    = "100"
    max_get_multi_batch_size     = "1000"
    dns_provider_update_interval = "10s"
  }
}

variable "cache_memcached_bucket_config" {
  default = {
    addresses                    = "thanos-memcached-0.thanos-memcached:11211, thanos-memcached-1.thanos-memcached:11211"
    timeout                      = "10s"
    max_idle_connections         = "100"
    max_async_concurrency        = "20"
    max_async_buffer_size        = "100000"
    max_item_size                = "16MB"
    max_get_multi_concurrency    = "100"
    max_get_multi_batch_size     = "1000"
    dns_provider_update_interval = "10s"
  }
}


variable "config_path_s3" {
  description = "path to secrets files"
  type        = string
  default     = "/thanos/secrets"
}

variable "config_s3" {
  default = {}
}

variable "service_account_name" {
  type    = string
  default = "default"
}

variable "automount_service_account_token" {
  type    = bool
  default = false
}

variable "service_account_token_name" {
  default = "default"
  type    = string
}
