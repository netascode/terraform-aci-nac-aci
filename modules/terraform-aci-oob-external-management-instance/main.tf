resource "aci_rest_managed" "mgmtInstP" {
  dn         = "uni/tn-mgmt/extmgmt-default/instp-${var.name}"
  class_name = "mgmtInstP"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "mgmtSubnet" {
  for_each   = toset(var.subnets)
  dn         = "${aci_rest_managed.mgmtInstP.dn}/subnet-[${each.value}]"
  class_name = "mgmtSubnet"
  content = {
    ip = each.value
  }
}

resource "aci_rest_managed" "mgmtRsOoBCons" {
  for_each   = toset(var.oob_contract_consumers)
  dn         = "${aci_rest_managed.mgmtInstP.dn}/rsooBCons-${each.value}"
  class_name = "mgmtRsOoBCons"
  content = {
    tnVzOOBBrCPName = each.value
  }
}
