module "test-0-default" {
  source = "../"
  rules_config = local.test_alert_configs
  path_configs = "${path.module}/rules"
}
