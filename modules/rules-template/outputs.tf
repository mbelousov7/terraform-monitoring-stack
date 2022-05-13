output "filenames" {
  description = "Filenames"
  value       = [for k, v in resource.local_file.alertmanager_rules_template: k]
}

output "filepaths" {
  description = "Path to templated rules."
  value       = [for k, v in resource.local_file.alertmanager_rules_template: v.filename]
}