terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  rules_map = flatten([
    for item, item_config in var.rules_config : [
      for rule, rule_config in item_config.rules : {
        key = "${item}-${rule}.yml"
        value = templatefile("${var.path_configs}/${rule}.yml", {
          system = item
          rule_config = rule_config
      }) }
    ]
  ])
}

resource "local_file" "alertmanager_rules_template" {
  for_each = {for item in local.rules_map: item.key => item.value}
  content  = each.value
  filename = "${var.path_rules_output}/${each.key}"
}
