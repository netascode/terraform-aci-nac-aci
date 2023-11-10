resource "aci_rest_managed" "dhcpOptionPol" {
  dn         = "uni/tn-${var.tenant}/dhcpoptpol-${var.name}"
  class_name = "dhcpOptionPol"
  content = {
    descr = var.description
    name  = var.name
  }
}

resource "aci_rest_managed" "dhcpOption" {
  for_each   = { for opt in var.options : opt.name => opt }
  dn         = "${aci_rest_managed.dhcpOptionPol.dn}/opt-${each.value.name}"
  class_name = "dhcpOption"
  content = {
    id   = each.value.id
    data = each.value.data
    name = each.value.name
  }
}
