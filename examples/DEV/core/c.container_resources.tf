locals {

  container_resources_nginx = {
    DEV   = { requests_cpu = "0.2", limits_cpu = "0.2", requests_memory = "256M", limits_memory = "300M" }
    STAGE = { requests_cpu = "0.2", limits_cpu = "0.2", requests_memory = "256M", limits_memory = "300M" }
    PROD  = { requests_cpu = "0.2", limits_cpu = "0.2", requests_memory = "256M", limits_memory = "300M" }
  }

  container_resources_grafana = {
    DEV   = { requests_cpu = "0.1", limits_cpu = "0.1", requests_memory = "250M", limits_memory = "250M" }
    STAGE = { requests_cpu = "0.1", limits_cpu = "0.1", requests_memory = "250M", limits_memory = "250M" }
    PROD  = { requests_cpu = "0.3", limits_cpu = "0.3", requests_memory = "350M", limits_memory = "350M" }
  }

  container_resources_prometheus_infra = {
    DEV   = { requests_cpu = "0.3", limits_cpu = "0.3", requests_memory = "900M", limits_memory = "900M" }
    STAGE = { requests_cpu = "0.3", limits_cpu = "0.3", requests_memory = "900M", limits_memory = "900M" }
    PROD  = { requests_cpu = "2.0", limits_cpu = "2.0", requests_memory = "3000M", limits_memory = "3000M" }
  }

  container_resources_prometheus_h = {
    DEV   = { requests_cpu = "0.3", limits_cpu = "0.3", requests_memory = "1200M", limits_memory = "1200M" }
    STAGE = { requests_cpu = "0.3", limits_cpu = "0.3", requests_memory = "1200M", limits_memory = "1200M" }
    PROD  = { requests_cpu = "2.0", limits_cpu = "2.0", requests_memory = "5000M", limits_memory = "5000M" }
  }

  container_resources_prometheus_pg = {
    DEV   = { requests_cpu = "0.5", limits_cpu = "0.5", requests_memory = "1524M", limits_memory = "1524M" }
    STAGE = { requests_cpu = "0.5", limits_cpu = "0.5", requests_memory = "1524M", limits_memory = "1524M" }
    PROD  = { requests_cpu = "1.5", limits_cpu = "1.5", requests_memory = "2500M", limits_memory = "2500M" }
  }

  container_resources_alertmanager = {
    DEV   = { requests_cpu = "0.1", limits_cpu = "0.1", requests_memory = "200M", limits_memory = "200M" }
    STAGE = { requests_cpu = "0.1", limits_cpu = "0.1", requests_memory = "200M", limits_memory = "200M" }
    PROD  = { requests_cpu = "0.2", limits_cpu = "0.2", requests_memory = "300M", limits_memory = "300M" }
  }

  container_resources_pushgateway = {
    DEV   = { requests_cpu = "0.1", limits_cpu = "0.1", requests_memory = "128M", limits_memory = "128M" }
    STAGE = { requests_cpu = "0.1", limits_cpu = "0.1", requests_memory = "128M", limits_memory = "128M" }
    PROD  = { requests_cpu = "0.2", limits_cpu = "0.2", requests_memory = "256M", limits_memory = "256M" }
  }

  container_resources_thanos_sidecar = {
    DEV   = { requests_cpu = "0.2", limits_cpu = "0.2", requests_memory = "400M", limits_memory = "400M" }
    STAGE = { requests_cpu = "0.2", limits_cpu = "0.2", requests_memory = "400M", limits_memory = "400M" }
    PROD  = { requests_cpu = "0.3", limits_cpu = "0.3", requests_memory = "500M", limits_memory = "500M" }
  }

  container_resources_thanos_query = {
    DEV   = { requests_cpu = "0.30", limits_cpu = "0.30", requests_memory = "1024M", limits_memory = "2048M" }
    STAGE = { requests_cpu = "0.30", limits_cpu = "0.30", requests_memory = "1024M", limits_memory = "2048M" }
    PROD  = { requests_cpu = "0.50", limits_cpu = "0.50", requests_memory = "1024M", limits_memory = "2048M" }
  }

  container_resources_thanos_query_frontend = {
    DEV   = { requests_cpu = "0.30", limits_cpu = "0.30", requests_memory = "512M", limits_memory = "600M", thanos_cache_max_size = "256MB" }
    STAGE = { requests_cpu = "0.30", limits_cpu = "0.30", requests_memory = "512M", limits_memory = "600M", thanos_cache_max_size = "256MB" }
    STAGE = { requests_cpu = "0.30", limits_cpu = "0.30", requests_memory = "512M", limits_memory = "600M", thanos_cache_max_size = "256MB" }
  }

  container_resources_thanos_store = {
    DEV   = { requests_cpu = "1.30", limits_cpu = "1.30", requests_memory = "2048M", limits_memory = "2500M", thanos_chunk_pool_size = "512MB", thanos_cache_max_size = "512MB" }
    STAGE = { requests_cpu = "0.30", limits_cpu = "0.30", requests_memory = "2048M", limits_memory = "2500M", thanos_chunk_pool_size = "512MB", thanos_cache_max_size = "512MB" }
    PROD  = { requests_cpu = "0.50", limits_cpu = "0.50", requests_memory = "2000M", limits_memory = "2500M", thanos_chunk_pool_size = "512MB", thanos_cache_max_size = "512MB" }
  }

  container_resources_thanos_compact = {
    DEV   = { requests_cpu = "2.00", limits_cpu = "2.00", requests_memory = "2000M", limits_memory = "2000M" }
    STAGE = { requests_cpu = "2.00", limits_cpu = "2.00", requests_memory = "2000M", limits_memory = "2000M" }
    PROD  = { requests_cpu = "2.00", limits_cpu = "1.00", requests_memory = "2000M", limits_memory = "2000M" }
  }

  thanos_compact_retention = {
    DEV   = { resolution_raw = "3d", resolution_5m = "3d", resolution_1h = "3d" }
    STAGE = { resolution_raw = "7d", resolution_5m = "7d", resolution_1h = "7d" }
    PROD  = { resolution_raw = "90d", resolution_5m = "365d", resolution_1h = "365d" }
  }

  container_resources_thanos_tools_bucket_web = {
    DEV   = { requests_cpu = "0.10", limits_cpu = "0.20", requests_memory = "50M", limits_memory = "50M" }
    STAGE = { requests_cpu = "0.10", limits_cpu = "0.20", requests_memory = "50M", limits_memory = "50M" }
    PROD  = { requests_cpu = "0.10", limits_cpu = "0.20", requests_memory = "50M", limits_memory = "50M" }
  }

}
