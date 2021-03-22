module "exporter-jmx-cloudera-infra-dev" {
  for_each         = local.cloudera-clh-cl-jmx
  source           = "../../../modules/exporter-jmx"
  namespace        = var.namespace
  label_system     = "clh-cl"
  config_maps_list = lookup(each.value, "config_maps_list", [])
  container_image  = var.exporter_jmx_container_image
  name             = "exporter-jmx-clh-cl-${each.key}"
  env              = each.value.env
  container_resources = lookup(
    each.value, "container_resources",
    lookup(local.exporter_jmx_roles_container_resources_map, each.value.env.JMX_ROLE)
  )
}

locals {
  cloudera-clh-cl-jmx = {
    cloudera001-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "cloudera001.dev.local", PORT = "9017" } }
    cloudera002-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "cloudera002.dev.local", PORT = "9017" } }
    cloudera003-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "cloudera003.dev.local", PORT = "9017" } }
    cloudera004-hiveserver2           = { env = { SERVICE = "hive", JMX_ROLE = "hiveserver2", HOST = "cloudera004.dev.local", PORT = "9017" } }
    cloudera001-hive-metastore-server = { env = { SERVICE = "hive", JMX_ROLE = "hive-metastore-server", HOST = "cloudera001.dev.local", PORT = "9018" } }
    cloudera002-hive-metastore-server = { env = { SERVICE = "hive", JMX_ROLE = "hive-metastore-server", HOST = "cloudera002.dev.local", PORT = "9018" } }
    cloudera001-zookeeper-server      = { env = { SERVICE = "zookeeper", JMX_ROLE = "zookeeper-server", HOST = "cloudera001.dev.local", PORT = "9010" } }
    cloudera002-zookeeper-server      = { env = { SERVICE = "zookeeper", JMX_ROLE = "zookeeper-server", HOST = "cloudera002.dev.local", PORT = "9010" } }
    cloudera003-zookeeper-server      = { env = { SERVICE = "zookeeper", JMX_ROLE = "zookeeper-server", HOST = "cloudera003.dev.local", PORT = "9010" } }
    cloudera001-hdfs-namenode         = { env = { SERVICE = "hdfs", JMX_ROLE = "hdfs-namenode", HOST = "cloudera001.dev.local", PORT = "9012" } }
    cloudera002-hdfs-namenode         = { env = { SERVICE = "hdfs", JMX_ROLE = "hdfs-namenode", HOST = "cloudera002.dev.local", PORT = "9012" } }
    cloudera002-oozie-server          = { env = { SERVICE = "oozie", JMX_ROLE = "oozie-server", HOST = "cloudera002.dev.local", PORT = "9015" } }
    cloudera003-oozie-server          = { env = { SERVICE = "oozie", JMX_ROLE = "oozie-server", HOST = "cloudera003.dev.local", PORT = "9015" } }
    cloudera004-sentry-server         = { env = { SERVICE = "sentry", JMX_ROLE = "sentry-server", HOST = "cloudera004.dev.local", PORT = "9016" } }
    cloudera005-sentry-server         = { env = { SERVICE = "sentry", JMX_ROLE = "sentry-server", HOST = "cloudera005.dev.local", PORT = "9016" } }
    cloudera005-impala-catalog-server = { env = { SERVICE = "impala", JMX_ROLE = "impala-catalog-server", HOST = "cloudera005.dev.local", PORT = "9028" } }
    cloudera004-hbase-master          = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-master", HOST = "cloudera004.dev.local", PORT = "9019" } }
    cloudera005-hbase-master          = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-master", HOST = "cloudera005.dev.local", PORT = "9019" } }
    cloudera004-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "cloudera004.dev.local", PORT = "9020" } }
    cloudera005-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "cloudera005.dev.local", PORT = "9020" } }
    cloudera006-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "cloudera006.dev.local", PORT = "9020" } }
    cloudera007-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "cloudera007.dev.local", PORT = "9020" } }
    cloudera008-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "cloudera008.dev.local", PORT = "9020" } }
    cloudera009-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "cloudera009.dev.local", PORT = "9020" } }
    cloudera010-hbase-regionserver    = { env = { SERVICE = "hbase", JMX_ROLE = "hbase-regionserver", HOST = "cloudera010.dev.local", PORT = "9020" } }
  }
}
