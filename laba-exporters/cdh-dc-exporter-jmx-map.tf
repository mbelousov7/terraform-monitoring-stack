locals {
  cdh_dc_exporter_jmx_map = {
    exporter-1 = {
      system = "cdh-dc"
      env = {
        JMX_ROLE = "default"
        HOST = "host1"
        PORT = "7777"
      }
    }
    exporter-2 = {
      system = "cdh-dc"
      env = {
        JMX_ROLE = "default"
        HOST = "host2"
        PORT = "7777"
      }
    }
  }
}
