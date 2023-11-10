resource "aci_rest_managed" "mgmtInB" {
  dn         = "uni/tn-mgmt/mgmtp-default/inb-${var.name}"
  class_name = "mgmtInB"
  content = {
    name  = var.name
    encap = "vlan-${var.vlan}"
  }
}

resource "aci_rest_managed" "fvRsProv" {
  for_each   = toset(var.contract_providers)
  dn         = "${aci_rest_managed.mgmtInB.dn}/rsprov-${each.value}"
  class_name = "fvRsProv"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest_managed" "fvRsCons" {
  for_each   = toset(var.contract_consumers)
  dn         = "${aci_rest_managed.mgmtInB.dn}/rscons-${each.value}"
  class_name = "fvRsCons"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest_managed" "fvRsConsIf" {
  for_each   = toset(var.contract_imported_consumers)
  dn         = "${aci_rest_managed.mgmtInB.dn}/rsconsIf-${each.value}"
  class_name = "fvRsConsIf"
  content = {
    tnVzCPIfName = each.value
  }
}

resource "aci_rest_managed" "mgmtRsMgmtBD" {
  dn         = "${aci_rest_managed.mgmtInB.dn}/rsmgmtBD"
  class_name = "mgmtRsMgmtBD"
  content = {
    tnFvBDName = var.bridge_domain
  }
}

resource "aci_rest_managed" "mgmtStaticRoute" {
  for_each   = toset(var.static_routes)
  dn         = "${aci_rest_managed.mgmtInB.dn}/staticroute-[${each.value}]"
  class_name = "mgmtStaticRoute"
  content = {
    prefix = each.value
  }
}