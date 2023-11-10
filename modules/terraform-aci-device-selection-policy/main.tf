resource "aci_rest_managed" "vnsLDevCtx" {
  dn         = "uni/tn-${var.tenant}/ldevCtx-c-${var.contract}-g-${var.service_graph_template}-n-N1"
  class_name = "vnsLDevCtx"
  content = {
    ctrctNameOrLbl : var.contract
    graphNameOrLbl : var.service_graph_template
    nodeNameOrLbl : "N1"
  }
}

resource "aci_rest_managed" "vnsRsLDevCtxToLDev" {
  dn         = "${aci_rest_managed.vnsLDevCtx.dn}/rsLDevCtxToLDev"
  class_name = "vnsRsLDevCtxToLDev"
  content = {
    tDn = "uni/tn-${var.sgt_device_tenant != "" ? var.sgt_device_tenant : var.tenant}/lDevVip-${var.sgt_device_name}"
  }
}

resource "aci_rest_managed" "vnsLIfCtx_consumer" {
  dn         = "${aci_rest_managed.vnsLDevCtx.dn}/lIfCtx-c-consumer"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "consumer",
    l3Dest        = var.consumer_l3_destination == true ? "yes" : "no"
    permitLog     = var.consumer_permit_logging == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcRedirectPol_consumer" {
  count      = var.consumer_redirect_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer.dn}/rsLIfCtxToSvcRedirectPol"
  class_name = "vnsRsLIfCtxToSvcRedirectPol"
  content = {
    tDn = "uni/tn-${var.consumer_redirect_policy_tenant != "" ? var.consumer_redirect_policy_tenant : var.tenant}/svcCont/svcRedirectPol-${var.consumer_redirect_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToBD_consumer" {
  count      = var.consumer_bridge_domain != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer.dn}/rsLIfCtxToBD"
  class_name = "vnsRsLIfCtxToBD"
  content = {
    tDn = "uni/tn-${var.consumer_bridge_domain_tenant != "" ? var.consumer_bridge_domain_tenant : var.tenant}/BD-${var.consumer_bridge_domain}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToInstP_consumer" {
  count      = var.consumer_external_endpoint_group != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer.dn}/rsLIfCtxToInstP"
  class_name = "vnsRsLIfCtxToInstP"
  content = {
    redistribute = join(",", concat(var.consumer_external_endpoint_group_redistribute_bgp == true ? ["bgp"] : [], var.consumer_external_endpoint_group_redistribute_connected == true ? ["connected"] : [], var.consumer_external_endpoint_group_redistribute_ospf == true ? ["ospf"] : [], var.consumer_external_endpoint_group_redistribute_static == true ? ["static"] : []))
    tDn          = "uni/tn-${var.consumer_external_endpoint_group_tenant != "" ? var.consumer_external_endpoint_group_tenant : var.tenant}/out-${var.consumer_external_endpoint_group_l3out}/instP-${var.consumer_external_endpoint_group}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_consumer" {
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer.dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = "uni/tn-${var.sgt_device_tenant != "" ? var.sgt_device_tenant : var.tenant}/lDevVip-${var.sgt_device_name}/lIf-${var.consumer_logical_interface}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_consumer" {
  count      = var.consumer_service_epg_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer.dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.consumer_service_epg_policy_tenant != "" ? var.consumer_service_epg_policy_tenant : var.tenant}/svcCont/svcEPgPol-${var.consumer_service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_consumer" {
  count      = var.consumer_custom_qos_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_consumer.dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = var.consumer_custom_qos_policy
  }
}

resource "aci_rest_managed" "vnsLIfCtx_provider" {
  dn         = "${aci_rest_managed.vnsLDevCtx.dn}/lIfCtx-c-provider"
  class_name = "vnsLIfCtx"
  content = {
    connNameOrLbl = "provider",
    l3Dest        = var.provider_l3_destination == true ? "yes" : "no"
    permitLog     = var.provider_permit_logging == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcRedirectPol_provider" {
  count      = var.provider_redirect_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_provider.dn}/rsLIfCtxToSvcRedirectPol"
  class_name = "vnsRsLIfCtxToSvcRedirectPol"
  content = {
    tDn = "uni/tn-${var.provider_redirect_policy_tenant != "" ? var.provider_redirect_policy_tenant : var.tenant}/svcCont/svcRedirectPol-${var.provider_redirect_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToBD_provider" {
  count      = var.provider_bridge_domain != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_provider.dn}/rsLIfCtxToBD"
  class_name = "vnsRsLIfCtxToBD"
  content = {
    tDn = "uni/tn-${var.provider_bridge_domain_tenant != "" ? var.provider_bridge_domain_tenant : var.tenant}/BD-${var.provider_bridge_domain}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToInstP_provider" {
  count      = var.provider_external_endpoint_group != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_provider.dn}/rsLIfCtxToInstP"
  class_name = "vnsRsLIfCtxToInstP"
  content = {
    redistribute = join(",", concat(var.provider_external_endpoint_group_redistribute_bgp == true ? ["bgp"] : [], var.provider_external_endpoint_group_redistribute_connected == true ? ["connected"] : [], var.provider_external_endpoint_group_redistribute_ospf == true ? ["ospf"] : [], var.provider_external_endpoint_group_redistribute_static == true ? ["static"] : []))
    tDn          = "uni/tn-${var.provider_external_endpoint_group_tenant != "" ? var.provider_external_endpoint_group_tenant : var.tenant}/out-${var.provider_external_endpoint_group_l3out}/instP-${var.provider_external_endpoint_group}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToLIf_provider" {
  dn         = "${aci_rest_managed.vnsLIfCtx_provider.dn}/rsLIfCtxToLIf"
  class_name = "vnsRsLIfCtxToLIf"
  content = {
    tDn = "uni/tn-${var.sgt_device_tenant != "" ? var.sgt_device_tenant : var.tenant}/lDevVip-${var.sgt_device_name}/lIf-${var.provider_logical_interface}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_provider" {
  count      = var.provider_service_epg_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_provider.dn}/rsLIfCtxToSvcEPgPol"
  class_name = "vnsRsLIfCtxToSvcEPgPol"
  content = {
    tDn = "uni/tn-${var.provider_service_epg_policy_tenant != "" ? var.provider_service_epg_policy_tenant : var.tenant}/svcCont/svcEPgPol-${var.provider_service_epg_policy}"
  }
}

resource "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_provider" {
  count      = var.provider_custom_qos_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLIfCtx_provider.dn}/rsLIfCtxToCustQosPol"
  class_name = "vnsRsLIfCtxToCustQosPol"
  content = {
    tnQosCustomPolName = var.provider_custom_qos_policy
  }
}
