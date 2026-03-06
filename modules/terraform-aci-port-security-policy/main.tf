resource "aci_rest_managed" "l2PortSecurityPol" {
  dn         = "uni/infra/portsecurityP-${var.name}"
  class_name = "l2PortSecurityPol"
  content = {
    name    = var.name
    descr   = var.description
    maximum = var.maximum_endpoints
    timeout = var.timeout
  }
}
