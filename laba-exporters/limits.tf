locals {

//мапа определения ресурсов в зависимости от роли экспортера
//должны быть определена для всех возможных ролей
  exporter_jmx_roles_resources_map = {
    default = {
      container_resources_requests_cpu = "20m"
      container_resources_limits_cpu = "40m"
      container_resources_requests_memory = "64M"
      container_resources_limits_memory = "128M"
    },
    debug = {
      container_resources_requests_cpu = "40m"
      container_resources_limits_cpu = "80m"
      container_resources_requests_memory = "128M"
      container_resources_limits_memory = "264M"
    }
    hbase-master = {
      container_resources_requests_cpu = "20m"
      container_resources_limits_cpu = "40m"
      container_resources_requests_memory = "64M"
      container_resources_limits_memory = "128M"
    }
  }

}
