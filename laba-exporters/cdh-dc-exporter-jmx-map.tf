locals {
  cdh_dc_exporter_jmx_map = {
    exporter-1 = {
      system = "cdh-dc"
      env_jmx_role = "default"
      env_host = "host1"
      env_port = "5555"
    }
    exporter-2 = {
      system = "cdh-dc"
      env_jmx_role = "default"
      env_host = "host2"
      env_port = "6666"
    }
  }
}
