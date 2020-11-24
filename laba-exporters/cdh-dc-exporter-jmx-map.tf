locals {
  cdh_dc_exporter_jmx_map = {
    //простой пример описания экспортера с минимальным набором параметров
    exporter-jmx-host1-7777-default = { system = "cdh-dc", env = { JMX_ROLE = "default", HOST = "host1", PORT = "7777"} },
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
          map_name = "config"
          map_path = "/opt/exporter-jmx/configs/"
          map_data = {
            "default.yml" = file("./exporter-jmx/default.yml")
          }
        }
      ]
    }
  }
}
