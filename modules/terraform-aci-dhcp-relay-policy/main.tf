resource "aci_rest_managed" "dhcpRelayP" {
  dn         = "uni/tn-${var.tenant}/relayp-${var.name}"
  class_name = "dhcpRelayP"
  content = {
    owner = "tenant"
    descr = var.description
    name  = var.name
  }
}

resource "aci_rest_managed" "dhcpRsProv" {
  for_each   = { for prov in var.providers_ : prov.ip => prov }
  dn         = each.value.type == "epg" ? "${aci_rest_managed.dhcpRelayP.dn}/rsprov-[uni/tn-${lookup(each.value, "tenant", var.tenant)}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}]" : "${aci_rest_managed.dhcpRelayP.dn}/rsprov-[uni/tn-${lookup(each.value, "tenant", var.tenant)}/out-${each.value.l3out}/instP-${each.value.external_endpoint_group}]"
  class_name = "dhcpRsProv"
  content = {
    tDn  = each.value.type == "epg" ? "uni/tn-${lookup(each.value, "tenant", var.tenant)}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}" : "uni/tn-${lookup(each.value, "tenant", var.tenant)}/out-${each.value.l3out}/instP-${each.value.external_endpoint_group}"
    addr = each.value.ip
  }
}
