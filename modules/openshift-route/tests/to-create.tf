module "test-0-default" {
  source             = "../"
  route_namespace    = "test-namespace"
  route_name         = "test"
  route_suffix       = "example.com"
  route_service_port = "9999"
  route_service_name = "service"
}

module "test-10-with-prefix" {
  source             = "../"
  route_namespace    = "test-namespace"
  route_name         = "test-with-prefix"
  route_prefix       = "prefix"
  route_suffix       = "example.com"
  route_service_port = "9999"
  route_service_name = "service"
}