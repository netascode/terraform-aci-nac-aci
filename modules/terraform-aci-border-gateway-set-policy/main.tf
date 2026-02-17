resource "aci_rest_managed" "vxlanSite" {
  dn         = "uni/tn-infra/vxlansite"
  class_name = "vxlanSite"
  content = {
    id = var.vxlan_site_id
  }
}

resource "aci_rest_managed" "vxlanBgwSet" {
  dn         = "uni/tn-infra/vxlanbgwset-${var.name}"
  class_name = "vxlanBgwSet"
  content = {
    name = var.name
  }

  depends_on = [aci_rest_managed.vxlanSite]
}

resource "aci_rest_managed" "vxlanExtAnycastIP" {
  for_each   = { for ip in var.external_data_plane_ips : ip.pod_id => ip }
  dn         = "uni/tn-infra/vxlanbgwset-${var.name}/vxlanextanycastip-${each.value.pod_id}"
  class_name = "vxlanExtAnycastIP"
  content = {
    podId = each.value.pod_id
    addr  = each.value.ip
  }

  depends_on = [aci_rest_managed.vxlanBgwSet]
}