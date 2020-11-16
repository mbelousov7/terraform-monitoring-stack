locals {
  cdh_dc_exporter_jmx_map = {
    //простой пример описания экспортера с минимальным набором параметров
    exporter-1 = {
      system = "cdh-dc"
      env = {
        JMX_ROLE = "default"
        HOST = "host1"
        PORT = "7777"
      }
    },
    exporter-2 = {
      system = "cdh-dc"
      env = {
        JMX_ROLE = "debug"
        HOST = "host1"
        PORT = "7777"
      }
    },
    exporter-3 = {
      system = "cdh-dc"
      env = {
        JMX_ROLE = "default"
        HOST = "host2"
        PORT = "7777"
      }
      //если хотим переопределить лимиты контейнера, например для поиска оптимальных начений
      container_resources_requests_cpu = "99m"
      container_resources_limits_cpu = "149m"
      container_resources_requests_memory = "198Mi"
      container_resources_limits_memory = "398Mi"
      //если хотим использовать конфиг мониторинга не из самого имаджа,
      // например при настройке сбора новых метрик,
      // то можем замаунтить поверх свои конфиг мапу
      config_maps_list = [
        {
          mount_path = "/opt/exporter-jmx/configs/"
          name = "config"
          config_map_name = "default"
          config_map_data = {
            "default.yaml" = file("./exporter-jmx/default.yaml")
          }
        }
      ]
    }
  }
}
