module "exporter-jmx-ambari-infra-dev" {
  for_each         = local.ambari-amh-cl-jmx
  source           = "../../../modules/exporter-jmx"
  namespace        = var.namespace
  label_system     = "amh-cl"
  config_maps_list = lookup(each.value, "config_maps_list", [])
  container_image  = var.exporter_jmx_container_image
  name             = "exporter-jmx-amh-cl-${each.key}"
  env              = each.value.env
  container_resources = lookup(
    each.value, "container_resources",
    lookup(local.exporter_jmx_roles_container_resources_map, each.value.env.JMX_ROLE)
  )
}

locals {
  ambari-amh-cl-jmx = {
    ambari002-yarn-rm               = { env = { SERVICE = "yarn", JMX_ROLE = "yarn-rm", HOST = "ambari002.dev.local", PORT = "9011" } }
    ambari002-yarn-rm-q0            = { env = { SERVICE = "yarn", JMX_ROLE = "yarn-rm-q0", HOST = "ambari002.dev.local", PORT = "9011" } }
    ambari002-yarn-rm-q4            = { env = { SERVICE = "yarn", JMX_ROLE = "yarn-rm-q4", HOST = "ambari002.dev.local", PORT = "9011" } }
    ambari002-yarn-rm-q1            = { env = { SERVICE = "yarn", JMX_ROLE = "yarn-rm-q1", HOST = "ambari002.dev.local", PORT = "9011" } }
    ambari002-yarn-rm-q2            = { env = { SERVICE = "yarn", JMX_ROLE = "yarn-rm-q2", HOST = "ambari002.dev.local", PORT = "9011" } }
    ambari002-yarn-rm-q3            = { env = { SERVICE = "yarn", JMX_ROLE = "yarn-rm-q3", HOST = "ambari002.dev.local", PORT = "9011" } }
    ambari001-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "ambari001.dev.local", PORT = "9017" } }
    ambari002-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "ambari002.dev.local", PORT = "9017" } }
    ambari003-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "ambari003.dev.local", PORT = "9017" } }
    ambari004-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "ambari004.dev.local", PORT = "9017" } }
    ambari001-hive-metastore-server = { env = { SERVICE = "hive", JMX_ROLE = "hive-metastore-server", HOST = "ambari001.dev.local", PORT = "9018" } }
    ambari002-hive-metastore-server = { env = { SERVICE = "hive", JMX_ROLE = "hive-metastore-server", HOST = "ambari002.dev.local", PORT = "9018" } }
    ambari001-zookeeper-server      = { env = { SERVICE = "zookeeper", JMX_ROLE = "zookeeper-server", HOST = "ambari001.dev.local", PORT = "9010" } }
    ambari002-zookeeper-server      = { env = { SERVICE = "zookeeper", JMX_ROLE = "zookeeper-server", HOST = "ambari002.dev.local", PORT = "9010" } }
    ambari003-zookeeper-server      = { env = { SERVICE = "zookeeper", JMX_ROLE = "zookeeper-server", HOST = "ambari003.dev.local", PORT = "9010" } }
    ambari001-hdfs-namenode         = { env = { SERVICE = "hdfs", JMX_ROLE = "hdfs-namenode", HOST = "ambari001.dev.local", PORT = "9012" } }
    ambari002-hdfs-namenode         = { env = { SERVICE = "hdfs", JMX_ROLE = "hdfs-namenode", HOST = "ambari002.dev.local", PORT = "9012" } }
    ambari002-oozie-server          = { env = { SERVICE = "oozie", JMX_ROLE = "oozie-server", HOST = "ambari002.dev.local", PORT = "9015" } }
    ambari003-oozie-server          = { env = { SERVICE = "oozie", JMX_ROLE = "oozie-server", HOST = "ambari003.dev.local", PORT = "9015" } }
    ambari004-sentry-server         = { env = { SERVICE = "sentry", JMX_ROLE = "sentry-server", HOST = "ambari004.dev.local", PORT = "9016" } }
    ambari005-sentry-server         = { env = { SERVICE = "sentry", JMX_ROLE = "sentry-server", HOST = "ambari005.dev.local", PORT = "9016" } }
    ambari005-impala-catalog-server = { env = { SERVICE = "impala", JMX_ROLE = "impala-catalog-server", HOST = "ambari005.dev.local", PORT = "9028" } }
    ambari004-hbase-master          = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-master", HOST = "ambari004.dev.local", PORT = "9019" } }
    ambari005-hbase-master          = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-master", HOST = "ambari005.dev.local", PORT = "9019" } }
    ambari004-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "ambari004.dev.local", PORT = "9020" } }
    ambari005-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "ambari005.dev.local", PORT = "9020" } }
    ambari006-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "ambari006.dev.local", PORT = "9020" } }
    ambari007-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "ambari007.dev.local", PORT = "9020" } }
    ambari008-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "ambari008.dev.local", PORT = "9020" } }
    ambari009-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "ambari009.dev.local", PORT = "9020" } }
    ambari010-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "ambari010.dev.local", PORT = "9020" } }
  }
}
