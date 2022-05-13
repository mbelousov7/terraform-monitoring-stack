locals {
  test_alert_configs = {
  ########################################################################################
    placeholder = {
      rules = {
        test_template = {
            filter = "noderole=\"test\"",
            labels = {
              test           = "test_label"
            },
            annotations = {
              info           = "http://info.address",
              dashboard_name = "system-hadoop", dashboard_uid = "R1LQYwQMz"
          }
        }
      }
    }
  }
}