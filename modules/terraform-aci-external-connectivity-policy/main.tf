locals {
  subnet_list = flatten([
    for prof in var.routing_profiles : [
      for subnet in prof.subnets : {
        id      = "${prof.name}-${subnet}"
        profile = prof.name
        subnet  = subnet
      }
    ]
  ])
}

resource "aci_rest_managed" "fvFabricExtConnP" {
  dn         = "uni/tn-infra/fabricExtConnP-${var.fabric_id}"
  class_name = "fvFabricExtConnP"
  content = {
    id     = var.fabric_id
    name   = var.name
    rt     = var.route_target
    siteId = var.site_id
  }
}

resource "aci_rest_managed" "fvPeeringP" {
  dn          = "${aci_rest_managed.fvFabricExtConnP.dn}/peeringP"
  class_name  = "fvPeeringP"
  escape_html = false
  content = {
    type     = var.peering_type == "full_mesh" ? "automatic_with_full_mesh" : "automatic_with_rr"
    password = var.bgp_password
  }

  lifecycle {
    ignore_changes = [content["password"]]
  }
}

resource "aci_rest_managed" "l3extFabricExtRoutingP" {
  for_each   = { for profile in var.routing_profiles : profile.name => profile }
  dn         = "${aci_rest_managed.fvFabricExtConnP.dn}/fabricExtRoutingP-${each.value.name}"
  class_name = "l3extFabricExtRoutingP"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
}

resource "aci_rest_managed" "l3extSubnet" {
  for_each   = { for subnet in local.subnet_list : subnet.id => subnet }
  dn         = "${aci_rest_managed.l3extFabricExtRoutingP[each.value.profile].dn}/extsubnet-[${each.value.subnet}]"
  class_name = "l3extSubnet"
  content = {
    ip    = each.value.subnet
    scope = "import-security"
  }
}

resource "aci_rest_managed" "fvPodConnP" {
  for_each   = { for tep in var.data_plane_teps : tep.pod_id => tep }
  dn         = "${aci_rest_managed.fvFabricExtConnP.dn}/podConnP-${each.value.pod_id}"
  class_name = "fvPodConnP"
  content = {
    id = each.value.pod_id
  }
}

resource "aci_rest_managed" "fvIp" {
  for_each   = { for tep in var.data_plane_teps : tep.pod_id => tep }
  dn         = "${aci_rest_managed.fvPodConnP[each.value.pod_id].dn}/ip-[${each.value.ip}]"
  class_name = "fvIp"
  content = {
    addr = each.value.ip
  }
}

resource "aci_rest_managed" "fvExtRoutableUcastConnP" {
  for_each   = { for tep in var.unicast_teps : tep.pod_id => tep }
  dn         = "${aci_rest_managed.fvPodConnP[each.value.pod_id].dn}/extRtUcastConnP-[${each.value.ip}]"
  class_name = "fvExtRoutableUcastConnP"
  content = {
    addr = each.value.ip
  }
}
