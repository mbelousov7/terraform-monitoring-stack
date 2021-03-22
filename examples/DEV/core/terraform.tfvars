//DEV
prometheus_pg_adapter_env = {
  TS_PROM_PG_HOST                                             = "timescaledb.local"
  TS_PROM_WEB_LISTEN_ADDRESS                                  = "0.0.0.0:9201"
  TS_PROM_PG_DATABASE                                         = "prometheus"
  TS_PROM_PG_PORT                                             = "5432"
  TS_PROM_PG_SCHEMA                                           = "prometheus"
  TS_PROM_PG_SSL_MODE                                         = "verify-ca"
  TS_PROM_LOG_LEVEL                                           = "warn"
  TS_PROM_LEADER_ELECTION_PG_ADVISORY_LOCK_ID                 = "1"
  TS_PROM_LEADER_ELECTION_PG_ADVISORY_LOCK_PROMETHEUS_TIMEOUT = "400s"
}

prometheus_os_host = "https://prometheus-os.local"

elasticsearch = {
  host = "elastic.local"
  port = "9201"
}

alertmanager_receivers_email = {
  default = "monitoring-admin@exchtest.local"
  kafka   = "monitoring@exchtest.local, monitoring-kafka@exchtest.local"
}

fluentbit_config_output = {
  host   = "logstash.local"
  port   = "9202"
  app_id = "grafana"
}
