nginx_users_map     = {
    user = "$apr1$A3L4.ORj$xGd9QkfCjDHS8tZWQldOP0" //user
    admin = "$apr1$GqeZ89R1$.qHQjuvzJIdWaFS413SgA/" //P@ssw0rd
}

prometheus_os_user = "admin"
prometheus_os_password = "P@ssw0rd"

monitoring_password = "P@ssw0rd"

prometheus_pg_adapter_env_secret = {
  TS_PROM_PG_USER = "prometheus"
  TS_PROM_PG_PASSWORD = "P@ssw0rd"
}

//local grafana admin
grafana_admin_user = "admin"
grafana_admin_password = "P@ssw0rd"
//Grafana ipa integration paramaters
grafana_ldap_host = "ipa1.local"
grafana_ldap_bind_user = "u_grafana"
grafana_ldap_bind_password = "P@ssw0rd"
grafana_ldap_bind_suffix = "dc=dev,dc=local"


alertmanager_smtp_smarthost = "email.local:25"
alertmanager_smtp_from = "monitoring-admin@email.local"
alertmanager_smtp_auth_username = "monitoring-admin"
alertmanager_smtp_auth_password = "P@ssw0rd"

//config_s3 - нужен только если есть интеграция с s3 object store
config_s3 = {
  "config-s3.yml" = <<EOF
  type: S3
  config:
    bucket: "thanos-metrics-dev"
    endpoint: "s3.local:443"
    region: ""
    access_key: "asdasdasdadasdasdasdadasdasd"
    insecure: false
    signature_version2: false
    secret_key: "asdadsadasdasdasdasdadasdasd"
    put_user_metadata: {}
    http_config:
      idle_conn_timeout: 1m30s
      response_header_timeout: 2m
      insecure_skip_verify: true
    trace:
      enable: false
    list_objects_version: ""
    part_size: 0
    #sse_config:
      #type: "SSE-C"
      #kms_key_id: ""
      #kms_encryption_context: {}
      #encryption_key: /thanos/secrets/encryption_key
EOF
}
