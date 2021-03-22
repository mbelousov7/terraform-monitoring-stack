locals {

  //мапа определения ресурсов в зависимости от роли экспортера
  //должны быть определена для всех возможных ролей
  exporter_jmx_roles_container_resources_map = {
    default               = { requests_cpu = "50m", limits_cpu = "50m", requests_memory = "128M", limits_memory = "128M" }
    debug                 = { requests_cpu = "50m", limits_cpu = "50m", requests_memory = "128M", limits_memory = "264M" }
    kafka                 = { requests_cpu = "150m", limits_cpu = "150m", requests_memory = "128M", limits_memory = "128M" }
    yarn-rm               = { requests_cpu = "50m", limits_cpu = "50m", requests_memory = "150M", limits_memory = "160M" }
    yarn-rm-q0            = { requests_cpu = "50m", limits_cpu = "50m", requests_memory = "150M", limits_memory = "160M" }
    yarn-rm-q1            = { requests_cpu = "90m", limits_cpu = "90m", requests_memory = "250M", limits_memory = "260M" }
    yarn-rm-q2            = { requests_cpu = "90m", limits_cpu = "90m", requests_memory = "250M", limits_memory = "260M" }
    yarn-rm-q3            = { requests_cpu = "60m", limits_cpu = "60m", requests_memory = "150M", limits_memory = "160M" }
    yarn-rm-q4            = { requests_cpu = "60m", limits_cpu = "60m", requests_memory = "150M", limits_memory = "160M" }
    hbase-master          = { requests_cpu = "30m", limits_cpu = "30m", requests_memory = "100M", limits_memory = "120M" }
    hbase-regionserver    = { requests_cpu = "40m", limits_cpu = "40m", requests_memory = "120M", limits_memory = "180M" }
    hiveserver2           = { requests_cpu = "40m", limits_cpu = "40m", requests_memory = "120M", limits_memory = "130M" }
    hive-metastore-server = { requests_cpu = "30m", limits_cpu = "30m", requests_memory = "120M", limits_memory = "130M" }
    hdfs-namenode         = { requests_cpu = "30m", limits_cpu = "30m", requests_memory = "120M", limits_memory = "180M" }
    oozie-server          = { requests_cpu = "90m", limits_cpu = "90m", requests_memory = "160M", limits_memory = "190M" }
    sentry-server         = { requests_cpu = "40m", limits_cpu = "40m", requests_memory = "120M", limits_memory = "130M" }
    zookeeper-server      = { requests_cpu = "150m", limits_cpu = "200m", requests_memory = "150M", limits_memory = "250M" }
    impala-catalog-server = { requests_cpu = "30m", limits_cpu = "30m", requests_memory = "120M", limits_memory = "130M" }
  }
}
