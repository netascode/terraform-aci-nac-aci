resource "aci_rest_managed" "coppIfPol" {
  dn         = "uni/infra/coppifpol-${var.name}"
  class_name = "coppIfPol"

  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "coppProtoClassP" {
  for_each   = { for pcp in var.protocol_policies : pcp.name => pcp }
  dn         = "${aci_rest_managed.coppIfPol.dn}/protoclassp-${each.value.name}"
  class_name = "coppProtoClassP"

  content = {
    name       = each.value.name
    rate       = each.value.rate
    burst      = each.value.burst
    matchProto = try(join(",", sort(each.value.match_protocols)), null)
  }
}