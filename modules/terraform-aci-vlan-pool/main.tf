resource "aci_rest_managed" "fvnsVlanInstP" {
  dn         = "uni/infra/vlanns-[${var.name}]-${var.allocation}"
  class_name = "fvnsVlanInstP"
  content = {
    name      = var.name
    descr     = var.description
    allocMode = var.allocation
  }
}

resource "aci_rest_managed" "fvnsEncapBlk" {
  for_each   = { for range in var.ranges : range.from => range }
  dn         = "${aci_rest_managed.fvnsVlanInstP.dn}/from-[vlan-${each.value.from}]-to-[${each.value.to == null ? "vlan-${each.value.from}" : "vlan-${each.value.to}"}]"
  class_name = "fvnsEncapBlk"
  content = {
    descr     = each.value.description
    from      = "vlan-${each.value.from}"
    to        = each.value.to == null ? "vlan-${each.value.from}" : "vlan-${each.value.to}"
    allocMode = each.value.allocation
    role      = each.value.role
  }
}
