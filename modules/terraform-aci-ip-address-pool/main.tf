resource "aci_rest_managed" "fvnsAddrInst" {
  dn         = "uni/tn-mgmt/addrinst-${var.name}"
  class_name = "fvnsAddrInst"
  content = {
    name      = var.name
    descr     = var.description
    addr      = var.gateway_address
    addrType  = "regular"
    skipGwVal = var.skip_gateway_validation == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "fvnsUcastAddrBlk" {
  for_each = { for range in var.address_ranges : "${range.from}-${range.to}" => range }

  dn         = "${aci_rest_managed.fvnsAddrInst.dn}/fromaddr-[${each.value.from}]-toaddr-[${each.value.to}]"
  class_name = "fvnsUcastAddrBlk"
  content = {
    from = each.value.from
    to   = each.value.to
  }
}
