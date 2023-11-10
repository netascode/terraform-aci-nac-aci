resource "aci_rest_managed" "mgmtOoB" {
  dn         = "uni/tn-mgmt/mgmtp-default/oob-${var.name}"
  class_name = "mgmtOoB"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "mgmtRsOoBProv" {
  for_each   = toset(var.oob_contract_providers)
  dn         = "${aci_rest_managed.mgmtOoB.dn}/rsooBProv-${each.value}"
  class_name = "mgmtRsOoBProv"
  content = {
    tnVzOOBBrCPName = each.value
  }
}

resource "aci_rest_managed" "mgmtStaticRoute" {
  for_each   = toset(var.static_routes)
  dn         = "${aci_rest_managed.mgmtOoB.dn}/staticroute-[${each.value}]"
  class_name = "mgmtStaticRoute"
  content = {
    prefix = each.value
  }
}