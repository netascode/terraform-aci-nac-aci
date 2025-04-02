resource "aci_rest_managed" "vmmDomP" {
  dn         = "uni/vmmp-VMware/dom-${var.name}"
  class_name = "vmmDomP"
  content = {
    name       = var.name
    accessMode = var.access_mode
    delimiter  = var.delimiter
    enableTag  = var.tag_collection == true ? "yes" : "no"
    mode       = "default"
  }
}

resource "aci_rest_managed" "infraRsVlanNs" {
  dn         = "${aci_rest_managed.vmmDomP.dn}/rsvlanNs"
  class_name = "infraRsVlanNs"
  content = {
    tDn = "uni/infra/vlanns-[${var.vlan_pool}]-${var.allocation}"
  }
}

resource "aci_rest_managed" "vmmVSwitchPolicyCont" {
  dn         = "${aci_rest_managed.vmmDomP.dn}/vswitchpolcont"
  class_name = "vmmVSwitchPolicyCont"
}

resource "aci_rest_managed" "vmmRsVswitchOverrideLldpIfPol" {
  count      = var.vswitch_lldp_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vmmVSwitchPolicyCont.dn}/rsvswitchOverrideLldpIfPol"
  class_name = "vmmRsVswitchOverrideLldpIfPol"
  content = {
    tDn = "uni/infra/lldpIfP-${var.vswitch_lldp_policy}"
  }
}

resource "aci_rest_managed" "vmmRsVswitchOverrideCdpIfPol" {
  count      = var.vswitch_cdp_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vmmVSwitchPolicyCont.dn}/rsvswitchOverrideCdpIfPol"
  class_name = "vmmRsVswitchOverrideCdpIfPol"
  content = {
    tDn = "uni/infra/cdpIfP-${var.vswitch_cdp_policy}"
  }
}

resource "aci_rest_managed" "vmmRsVswitchOverrideLacpPol" {
  count      = var.vswitch_port_channel_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vmmVSwitchPolicyCont.dn}/rsvswitchOverrideLacpPol"
  class_name = "vmmRsVswitchOverrideLacpPol"
  content = {
    tDn = "uni/infra/lacplagp-${var.vswitch_port_channel_policy}"
  }
}

resource "aci_rest_managed" "vmmRsVswitchOverrideMtuPol" {
  count      = var.vswitch_mtu_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vmmVSwitchPolicyCont.dn}/rsvswitchOverrideMtuPol"
  class_name = "vmmRsVswitchOverrideMtuPol"
  content = {
    tDn = "uni/fabric/l2pol-${var.vswitch_mtu_policy}"
  }
}

resource "aci_rest_managed" "vmmRsVswitchExporterPol" {
  count      = var.vswitch_netflow_policy != "" ? 1 : 0
  dn         = "${aci_rest_managed.vmmVSwitchPolicyCont.dn}/rsvswitchExporterPol-[uni/infra/vmmexporterpol-${var.vswitch_netflow_policy}]"
  class_name = "vmmRsVswitchExporterPol"
  content = {
    tDn = "uni/infra/vmmexporterpol-${var.vswitch_netflow_policy}"
  }
}

resource "aci_rest_managed" "lacpEnhancedLagPol" {
  for_each   = { for elag in var.vswitch_enhanced_lags : elag.name => elag }
  dn         = "${aci_rest_managed.vmmVSwitchPolicyCont.dn}/enlacplagp-${each.value.name}"
  class_name = "lacpEnhancedLagPol"
  content = {
    name     = each.value.name
    lbmode   = each.value.lb_mode
    mode     = each.value.mode
    numLinks = each.value.num_links
  }
}

resource "aci_rest_managed" "vmmCtrlrP" {
  for_each   = { for vc in var.vcenters : vc.name => vc }
  dn         = "${aci_rest_managed.vmmDomP.dn}/ctrlr-${each.value.name}"
  class_name = "vmmCtrlrP"
  content = {
    dvsVersion      = each.value.dvs_version
    hostOrIp        = each.value.hostname_ip
    inventoryTrigSt = "untriggered"
    mode            = "default"
    name            = each.value.name
    port            = "0"
    rootContName    = each.value.datacenter
    scope           = "vm"
    statsMode       = each.value.statistics == true ? "enabled" : "disabled"
  }
}

resource "aci_rest_managed" "vmmUsrAccP" {
  for_each    = { for cred in var.credential_policies : cred.name => cred }
  dn          = "${aci_rest_managed.vmmDomP.dn}/usracc-${each.value.name}"
  class_name  = "vmmUsrAccP"
  escape_html = false
  content = {
    name = each.value.name
    usr  = each.value.username
    pwd  = sensitive(each.value.password)
  }

  lifecycle {
    ignore_changes = [content["pwd"]]
  }
}

resource "aci_rest_managed" "vmmRsAcc" {
  for_each   = { for vc in var.vcenters : vc.name => vc if vc.credential_policy != null }
  dn         = "${aci_rest_managed.vmmCtrlrP[each.value.name].dn}/rsacc"
  class_name = "vmmRsAcc"
  content = {
    tDn = "uni/vmmp-VMware/dom-${var.name}/usracc-${each.value.credential_policy}"
  }
}

resource "aci_rest_managed" "vmmRsMgmtEPg" {
  for_each   = { for vc in var.vcenters : vc.name => vc if lookup(vc, "mgmt_epg_type", "inb") == "inb" && vc.mgmt_epg_name != null }
  dn         = "${aci_rest_managed.vmmCtrlrP[each.value.name].dn}/rsmgmtEPg"
  class_name = "vmmRsMgmtEPg"
  content = {
    tDn = "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}


resource "aci_rest_managed" "vmmUplinkPCont" {
  count      = length(var.uplinks) == 0 ? 0 : 1
  dn         = "${aci_rest_managed.vmmDomP.dn}/uplinkpcont"
  class_name = "vmmUplinkPCont"
  content = {
    numOfUplinks = tostring(length(var.uplinks))
  }
}

resource "aci_rest_managed" "vmmUplinkP" {
  for_each   = { for uplink in var.uplinks : uplink.id => uplink }
  dn         = "${aci_rest_managed.vmmUplinkPCont[0].dn}/uplinkp-${each.value.id}"
  class_name = "vmmUplinkP"
  content = {
    uplinkId   = each.value.id
    uplinkName = each.value.name
  }
}

resource "aci_rest_managed" "aaaDomainRef" {
  for_each   = toset(var.security_domains)
  dn         = "${aci_rest_managed.vmmDomP.dn}/domain-${each.value}"
  class_name = "aaaDomainRef"
  content = {
    name = each.value
  }
}