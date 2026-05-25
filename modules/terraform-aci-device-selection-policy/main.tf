locals {
  # Determine if we're in multi-device mode based on whether devices list is provided
  multi_device_mode = length(var.devices) > 0

  # Build a map of devices keyed by node_name (or name if node_name not provided)
  devices_map = {
    for idx, device in var.devices : coalesce(device.node_name, device.name) => {
      index     = idx
      name      = device.name
      tenant    = coalesce(device.tenant, var.tenant)
      node_name = coalesce(device.node_name, device.name)
      consumer = device.consumer != null ? {
        l3_destination                                 = device.consumer.l3_destination != null ? device.consumer.l3_destination : false
        permit_logging                                 = device.consumer.permit_logging != null ? device.consumer.permit_logging : false
        logical_interface                              = device.consumer.logical_interface
        redirect_policy                                = try(device.consumer.redirect_policy.name, "")
        redirect_policy_tenant                         = coalesce(try(device.consumer.redirect_policy.tenant, null), device.tenant, var.tenant)
        bridge_domain                                  = try(device.consumer.bridge_domain.name, "")
        bridge_domain_tenant                           = coalesce(try(device.consumer.bridge_domain.tenant, null), device.tenant, var.tenant)
        external_endpoint_group                        = try(device.consumer.external_endpoint_group.name, "")
        external_endpoint_group_l3out                  = try(device.consumer.external_endpoint_group.l3out, "")
        external_endpoint_group_tenant                 = coalesce(try(device.consumer.external_endpoint_group.tenant, null), device.tenant, var.tenant)
        external_endpoint_group_redistribute_bgp       = try(device.consumer.external_endpoint_group.redistribute.bgp, false)
        external_endpoint_group_redistribute_ospf      = try(device.consumer.external_endpoint_group.redistribute.ospf, false)
        external_endpoint_group_redistribute_connected = try(device.consumer.external_endpoint_group.redistribute.connected, false)
        external_endpoint_group_redistribute_static    = try(device.consumer.external_endpoint_group.redistribute.static, false)
        service_epg_policy                             = device.consumer.service_epg_policy != null ? device.consumer.service_epg_policy : ""
        custom_qos_policy                              = device.consumer.custom_qos_policy != null ? device.consumer.custom_qos_policy : ""
      } : null
      provider = device.provider != null ? {
        l3_destination                                 = device.provider.l3_destination != null ? device.provider.l3_destination : false
        permit_logging                                 = device.provider.permit_logging != null ? device.provider.permit_logging : false
        logical_interface                              = device.provider.logical_interface
        redirect_policy                                = try(device.provider.redirect_policy.name, "")
        redirect_policy_tenant                         = coalesce(try(device.provider.redirect_policy.tenant, null), device.tenant, var.tenant)
        bridge_domain                                  = try(device.provider.bridge_domain.name, "")
        bridge_domain_tenant                           = coalesce(try(device.provider.bridge_domain.tenant, null), device.tenant, var.tenant)
        external_endpoint_group                        = try(device.provider.external_endpoint_group.name, "")
        external_endpoint_group_l3out                  = try(device.provider.external_endpoint_group.l3out, "")
        external_endpoint_group_tenant                 = coalesce(try(device.provider.external_endpoint_group.tenant, null), device.tenant, var.tenant)
        external_endpoint_group_redistribute_bgp       = try(device.provider.external_endpoint_group.redistribute.bgp, false)
        external_endpoint_group_redistribute_ospf      = try(device.provider.external_endpoint_group.redistribute.ospf, false)
        external_endpoint_group_redistribute_connected = try(device.provider.external_endpoint_group.redistribute.connected, false)
        external_endpoint_group_redistribute_static    = try(device.provider.external_endpoint_group.redistribute.static, false)
        service_epg_policy                             = device.provider.service_epg_policy != null ? device.provider.service_epg_policy : ""
        custom_qos_policy                              = device.provider.custom_qos_policy != null ? device.provider.custom_qos_policy : ""
      } : null
      copy_service = device.copy_service != null ? {
        l3_destination     = device.copy_service.l3_destination != null ? device.copy_service.l3_destination : false
        permit_logging     = device.copy_service.permit_logging != null ? device.copy_service.permit_logging : false
        logical_interface  = device.copy_service.logical_interface
        service_epg_policy = device.copy_service.service_epg_policy != null ? device.copy_service.service_epg_policy : ""
        custom_qos_policy  = device.copy_service.custom_qos_policy != null ? device.copy_service.custom_qos_policy : ""
      } : null
    }
  }
}

# =============================================================================
# Legacy single-device mode resources (when devices list is NOT provided)
# =============================================================================

resource "aci_rest_managed" "vnsLDevCtx" {
  count      = local.multi_device_mode ? 0 : 1
  dn         = "uni/tn-${var.tenant}/ldevCtx-c-${var.contract}-g-${var.service_graph_template}-n-${var.node_name}"
  class_name = "vnsLDevCtx"
  content = {
    ctrctNameOrLbl : var.contract
    graphNameOrLbl : var.service_graph_template
    nodeNameOrLbl : var.node_name
  }
}

resource "aci_rest_managed" "vnsRsLDevCtxToLDev" {
  count      = local.multi_device_mode ? 0 : 1
  dn         = "${aci_rest_managed.vnsLDevCtx[0].dn}/rsLDevCtxToLDev"
  class_name = "vnsRsLDevCtxToLDev"
  content = {
    tDn = "uni/tn-${var.tenant}/${var.sgt_device_tenant != var.tenant ? "lDevIf-[uni/tn-${var.sgt_device_tenant}/lDevVip-${var.sgt_device_name}]" : "lDevVip-${var.sgt_device_name}"}"
  }
}

resource "aci_rest_managed" "vnsLIfCtx_consumer" {
  count      = local.multi_device_mode ? 0 : (var.consumer_logical_interface != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLDevCtx[0].dn}/lIfCtx-c-consumer"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "consumer",
    l3Dest        = var.consumer_l3_destination == true ? "yes" : "no"
    permitLog     = var.consumer_permit_logging == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcRedirectPol_consumer" {
  count      = local.multi_device_mode ? 0 : (var.consumer_logical_interface != "" && var.consumer_redirect_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer[0].dn}/rsLIfCtxToSvcRedirectPol"
  class_name = "vnsRsLIfCtxToSvcRedirectPol"
  content = {
    tDn = "uni/tn-${var.consumer_redirect_policy_tenant != "" ? var.consumer_redirect_policy_tenant : var.tenant}/svcCont/svcRedirectPol-${var.consumer_redirect_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToBD_consumer" {
  count      = local.multi_device_mode ? 0 : (var.consumer_logical_interface != "" && var.consumer_bridge_domain != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer[0].dn}/rsLIfCtxToBD"
  class_name = "vnsRsLIfCtxToBD"
  content = {
    tDn = "uni/tn-${var.consumer_bridge_domain_tenant != "" ? var.consumer_bridge_domain_tenant : var.tenant}/BD-${var.consumer_bridge_domain}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToInstP_consumer" {
  count      = local.multi_device_mode ? 0 : (var.consumer_logical_interface != "" && var.consumer_external_endpoint_group != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer[0].dn}/rsLIfCtxToInstP"
  class_name = "vnsRsLIfCtxToInstP"
  content = {
    redistribute = join(",", concat(var.consumer_external_endpoint_group_redistribute_bgp == true ? ["bgp"] : [], var.consumer_external_endpoint_group_redistribute_connected == true ? ["connected"] : [], var.consumer_external_endpoint_group_redistribute_ospf == true ? ["ospf"] : [], var.consumer_external_endpoint_group_redistribute_static == true ? ["static"] : []))
    tDn          = "uni/tn-${var.consumer_external_endpoint_group_tenant != "" ? var.consumer_external_endpoint_group_tenant : var.tenant}/out-${var.consumer_external_endpoint_group_l3out}/instP-${var.consumer_external_endpoint_group}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_consumer" {
  count      = local.multi_device_mode ? 0 : (var.consumer_logical_interface != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer[0].dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = "uni/tn-${var.tenant}/${var.sgt_device_tenant != var.tenant ? "lDevIf-[uni/tn-${var.sgt_device_tenant}/lDevVip-${var.sgt_device_name}]/lDevIfLIf-${var.consumer_logical_interface}" : "lDevVip-${var.sgt_device_name}/lIf-${var.consumer_logical_interface}"}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_consumer" {
  count      = local.multi_device_mode ? 0 : (var.consumer_logical_interface != "" && var.consumer_service_epg_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer[0].dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.consumer_service_epg_policy_tenant != "" ? var.consumer_service_epg_policy_tenant : var.tenant}/svcCont/svcEPgPol-${var.consumer_service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_consumer" {
  count      = local.multi_device_mode ? 0 : (var.consumer_logical_interface != "" && var.consumer_custom_qos_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer[0].dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = var.consumer_custom_qos_policy
  }
}

resource "aci_rest_managed" "vnsLIfCtx_provider" {
  count      = local.multi_device_mode ? 0 : (var.provider_logical_interface != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLDevCtx[0].dn}/lIfCtx-c-provider"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "provider",
    l3Dest        = var.provider_l3_destination == true ? "yes" : "no"
    permitLog     = var.provider_permit_logging == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcRedirectPol_provider" {
  count      = local.multi_device_mode ? 0 : (var.provider_logical_interface != "" && var.provider_redirect_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_provider[0].dn}/rsLIfCtxToSvcRedirectPol"
  class_name = "vnsRsLIfCtxToSvcRedirectPol"
  content = {
    tDn = "uni/tn-${var.provider_redirect_policy_tenant != "" ? var.provider_redirect_policy_tenant : var.tenant}/svcCont/svcRedirectPol-${var.provider_redirect_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToBD_provider" {
  count      = local.multi_device_mode ? 0 : (var.provider_logical_interface != "" && var.provider_bridge_domain != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_provider[0].dn}/rsLIfCtxToBD"
  class_name = "vnsRsLIfCtxToBD"
  content = {
    tDn = "uni/tn-${var.provider_bridge_domain_tenant != "" ? var.provider_bridge_domain_tenant : var.tenant}/BD-${var.provider_bridge_domain}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToInstP_provider" {
  count      = local.multi_device_mode ? 0 : (var.provider_logical_interface != "" && var.provider_external_endpoint_group != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_provider[0].dn}/rsLIfCtxToInstP"
  class_name = "vnsRsLIfCtxToInstP"
  content = {
    redistribute = join(",", concat(var.provider_external_endpoint_group_redistribute_bgp == true ? ["bgp"] : [], var.provider_external_endpoint_group_redistribute_connected == true ? ["connected"] : [], var.provider_external_endpoint_group_redistribute_ospf == true ? ["ospf"] : [], var.provider_external_endpoint_group_redistribute_static == true ? ["static"] : []))
    tDn          = "uni/tn-${var.provider_external_endpoint_group_tenant != "" ? var.provider_external_endpoint_group_tenant : var.tenant}/out-${var.provider_external_endpoint_group_l3out}/instP-${var.provider_external_endpoint_group}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_provider" {
  count      = local.multi_device_mode ? 0 : (var.provider_logical_interface != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_provider[0].dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = "uni/tn-${var.tenant}/${var.sgt_device_tenant != var.tenant ? "lDevIf-[uni/tn-${var.sgt_device_tenant}/lDevVip-${var.sgt_device_name}]/lDevIfLIf-${var.provider_logical_interface}" : "lDevVip-${var.sgt_device_name}/lIf-${var.provider_logical_interface}"}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_provider" {
  count      = local.multi_device_mode ? 0 : (var.provider_logical_interface != "" && var.provider_service_epg_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_provider[0].dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.provider_service_epg_policy_tenant != "" ? var.provider_service_epg_policy_tenant : var.tenant}/svcCont/svcEPgPol-${var.provider_service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_provider" {
  count      = local.multi_device_mode ? 0 : (var.provider_logical_interface != "" && var.provider_custom_qos_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_provider[0].dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = var.provider_custom_qos_policy
  }
}

resource "aci_rest_managed" "vnsLIfCtx_copy" {
  count      = local.multi_device_mode ? 0 : (var.copy_logical_interface != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLDevCtx[0].dn}/lIfCtx-c-copy"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "copy",
    l3Dest        = var.copy_l3_destination == true ? "yes" : "no"
    permitLog     = var.copy_permit_logging == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_copy" {
  count      = local.multi_device_mode ? 0 : (var.copy_logical_interface != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_copy[0].dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = "uni/tn-${var.tenant}/${var.sgt_device_tenant != var.tenant ? "lDevIf-[uni/tn-${var.sgt_device_tenant}/lDevVip-${var.sgt_device_name}]/lDevIfLIf-${var.copy_logical_interface}" : "lDevVip-${var.sgt_device_name}/lIf-${var.copy_logical_interface}"}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_copy" {
  count      = local.multi_device_mode ? 0 : (var.copy_logical_interface != "" && var.copy_service_epg_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_copy[0].dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.copy_service_epg_policy_tenant != "" ? var.copy_service_epg_policy_tenant : var.tenant}/svcCont/svcEPgPol-${var.copy_service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_copy" {
  count      = local.multi_device_mode ? 0 : (var.copy_logical_interface != "" && var.copy_custom_qos_policy != "" ? 1 : 0)
  dn         = "${aci_rest_managed.vnsLIfCtx_copy[0].dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = var.copy_custom_qos_policy
  }
}

# =============================================================================
# Multi-device mode resources (when devices list IS provided)
# =============================================================================

# vnsLDevCtx - One per device in the devices list
resource "aci_rest_managed" "vnsLDevCtx_multi" {
  for_each   = local.multi_device_mode ? local.devices_map : {}
  dn         = "uni/tn-${var.tenant}/ldevCtx-c-${var.contract}-g-${var.service_graph_template}-n-${each.value.node_name}"
  class_name = "vnsLDevCtx"
  content = {
    ctrctNameOrLbl = var.contract
    graphNameOrLbl = var.service_graph_template
    nodeNameOrLbl  = each.value.node_name
  }
}

# vnsRsLDevCtxToLDev - Links device context to L4L7 device
resource "aci_rest_managed" "vnsRsLDevCtxToLDev_multi" {
  for_each   = local.multi_device_mode ? local.devices_map : {}
  dn         = "${aci_rest_managed.vnsLDevCtx_multi[each.key].dn}/rsLDevCtxToLDev"
  class_name = "vnsRsLDevCtxToLDev"
  content = {
    tDn = each.value.tenant == var.tenant ? "uni/tn-${var.tenant}/lDevVip-${each.value.name}" : "uni/tn-${var.tenant}/lDevIf-[uni/tn-${each.value.tenant}/lDevVip-${each.value.name}]"
  }
}

# Consumer interface context for multi-device mode
resource "aci_rest_managed" "vnsLIfCtx_consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.consumer != null } : {}
  dn         = "${aci_rest_managed.vnsLDevCtx_multi[each.key].dn}/lIfCtx-c-consumer"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "consumer"
    l3Dest        = each.value.consumer.l3_destination ? "yes" : "no"
    permitLog     = each.value.consumer.permit_logging ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcRedirectPol_consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.consumer != null && v.consumer.redirect_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer_multi[each.key].dn}/rsLIfCtxToSvcRedirectPol"
  class_name = "vnsRsLIfCtxToSvcRedirectPol"
  content = {
    tDn = "uni/tn-${each.value.consumer.redirect_policy_tenant}/svcCont/svcRedirectPol-${each.value.consumer.redirect_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToBD_consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.consumer != null && v.consumer.bridge_domain != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer_multi[each.key].dn}/rsLIfCtxToBD"
  class_name = "vnsRsLIfCtxToBD"
  content = {
    tDn = "uni/tn-${each.value.consumer.bridge_domain_tenant}/BD-${each.value.consumer.bridge_domain}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToInstP_consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.consumer != null && v.consumer.external_endpoint_group != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer_multi[each.key].dn}/rsLIfCtxToInstP"
  class_name = "vnsRsLIfCtxToInstP"
  content = {
    redistribute = join(",", concat(
      each.value.consumer.external_endpoint_group_redistribute_bgp ? ["bgp"] : [],
      each.value.consumer.external_endpoint_group_redistribute_connected ? ["connected"] : [],
      each.value.consumer.external_endpoint_group_redistribute_ospf ? ["ospf"] : [],
      each.value.consumer.external_endpoint_group_redistribute_static ? ["static"] : []
    ))
    tDn = "uni/tn-${each.value.consumer.external_endpoint_group_tenant}/out-${each.value.consumer.external_endpoint_group_l3out}/instP-${each.value.consumer.external_endpoint_group}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.consumer != null } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer_multi[each.key].dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = each.value.tenant == var.tenant ? "uni/tn-${var.tenant}/lDevVip-${each.value.name}/lIf-${each.value.consumer.logical_interface}" : "uni/tn-${var.tenant}/lDevIf-[uni/tn-${each.value.tenant}/lDevVip-${each.value.name}]/lDevIfLIf-${each.value.consumer.logical_interface}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.consumer != null && v.consumer.service_epg_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer_multi[each.key].dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.tenant}/svcCont/svcEPgPol-${each.value.consumer.service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.consumer != null && v.consumer.custom_qos_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer_multi[each.key].dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = each.value.consumer.custom_qos_policy
  }
}

# Provider interface context for multi-device mode
resource "aci_rest_managed" "vnsLIfCtx_provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.provider != null } : {}
  dn         = "${aci_rest_managed.vnsLDevCtx_multi[each.key].dn}/lIfCtx-c-provider"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "provider"
    l3Dest        = each.value.provider.l3_destination ? "yes" : "no"
    permitLog     = each.value.provider.permit_logging ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcRedirectPol_provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.provider != null && v.provider.redirect_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_provider_multi[each.key].dn}/rsLIfCtxToSvcRedirectPol"
  class_name = "vnsRsLIfCtxToSvcRedirectPol"
  content = {
    tDn = "uni/tn-${each.value.provider.redirect_policy_tenant}/svcCont/svcRedirectPol-${each.value.provider.redirect_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToBD_provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.provider != null && v.provider.bridge_domain != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_provider_multi[each.key].dn}/rsLIfCtxToBD"
  class_name = "vnsRsLIfCtxToBD"
  content = {
    tDn = "uni/tn-${each.value.provider.bridge_domain_tenant}/BD-${each.value.provider.bridge_domain}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToInstP_provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.provider != null && v.provider.external_endpoint_group != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_provider_multi[each.key].dn}/rsLIfCtxToInstP"
  class_name = "vnsRsLIfCtxToInstP"
  content = {
    redistribute = join(",", concat(
      each.value.provider.external_endpoint_group_redistribute_bgp ? ["bgp"] : [],
      each.value.provider.external_endpoint_group_redistribute_connected ? ["connected"] : [],
      each.value.provider.external_endpoint_group_redistribute_ospf ? ["ospf"] : [],
      each.value.provider.external_endpoint_group_redistribute_static ? ["static"] : []
    ))
    tDn = "uni/tn-${each.value.provider.external_endpoint_group_tenant}/out-${each.value.provider.external_endpoint_group_l3out}/instP-${each.value.provider.external_endpoint_group}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.provider != null } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_provider_multi[each.key].dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = each.value.tenant == var.tenant ? "uni/tn-${var.tenant}/lDevVip-${each.value.name}/lIf-${each.value.provider.logical_interface}" : "uni/tn-${var.tenant}/lDevIf-[uni/tn-${each.value.tenant}/lDevVip-${each.value.name}]/lDevIfLIf-${each.value.provider.logical_interface}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.provider != null && v.provider.service_epg_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_provider_multi[each.key].dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.tenant}/svcCont/svcEPgPol-${each.value.provider.service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.provider != null && v.provider.custom_qos_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_provider_multi[each.key].dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = each.value.provider.custom_qos_policy
  }
}

# Copy service interface context for multi-device mode
resource "aci_rest_managed" "vnsLIfCtx_copy_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.copy_service != null } : {}
  dn         = "${aci_rest_managed.vnsLDevCtx_multi[each.key].dn}/lIfCtx-c-copy"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "copy"
    l3Dest        = each.value.copy_service.l3_destination ? "yes" : "no"
    permitLog     = each.value.copy_service.permit_logging ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_copy_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.copy_service != null } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_copy_multi[each.key].dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = each.value.tenant == var.tenant ? "uni/tn-${var.tenant}/lDevVip-${each.value.name}/lIf-${each.value.copy_service.logical_interface}" : "uni/tn-${var.tenant}/lDevIf-[uni/tn-${each.value.tenant}/lDevVip-${each.value.name}]/lDevIfLIf-${each.value.copy_service.logical_interface}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_copy_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.copy_service != null && v.copy_service.service_epg_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_copy_multi[each.key].dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.tenant}/svcCont/svcEPgPol-${each.value.copy_service.service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_copy_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.copy_service != null && v.copy_service.custom_qos_policy != "" } : {}
  dn         = "${aci_rest_managed.vnsLIfCtx_copy_multi[each.key].dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = each.value.copy_service.custom_qos_policy
  }
}
