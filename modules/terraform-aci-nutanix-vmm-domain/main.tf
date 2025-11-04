resource "aci_rest_managed" "vmmDomP" {
  dn         = "uni/vmmp-Nutanix/dom-${var.name}"
  class_name = "vmmDomP"
  content = {
    name             = var.name
    accessMode       = var.access_mode
    customSwitchName = var.custom_vswitch_name
    mode             = "nutanix_pc"
  }

  lifecycle {
    ignore_changes = [content["customSwitchName"]]
  }
}

resource "aci_rest_managed" "infraRsVlanNs" {
  dn         = "${aci_rest_managed.vmmDomP.dn}/rsvlanNs"
  class_name = "infraRsVlanNs"
  content = {
    tDn = try("uni/infra/vlanns-[${var.vlan_pool}]-${var.allocation}", null)
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

resource "aci_rest_managed" "vmmCtrlrP" {
  for_each   = { for cp in var.controller_profile : cp.name => cp }
  dn         = "${aci_rest_managed.vmmDomP.dn}/ctrlr-${each.value.name}"
  class_name = "vmmCtrlrP"
  content = {
    name            = each.value.name
    hostOrIp        = each.value.hostname_ip
    aosVersion      = each.value.aos_version
    inventoryTrigSt = "untriggered"
    mode            = "nutanix_pc"
    port            = "0"
    rootContName    = each.value.datacenter
    scope           = "nutanix"
    statsMode       = each.value.statistics == true ? "enabled" : "disabled"
  }
}

resource "aci_rest_managed" "vmmRsAcc" {
  for_each   = { for cp in var.controller_profile : cp.name => cp if cp.credentials != null }
  dn         = "${aci_rest_managed.vmmCtrlrP[each.value.name].dn}/rsacc"
  class_name = "vmmRsAcc"
  content = {
    tDn = "uni/vmmp-Nutanix/dom-${var.name}/usracc-${each.value.credentials}"
  }
}

resource "aci_rest_managed" "vmmClusterCtrlrP" {
  for_each   = { for cp in var.cluster_controller : cp.name => cp }
  dn         = "${aci_rest_managed.vmmCtrlrP[each.value.controller_profile].dn}/clusterctrlr-${each.value.name}"
  class_name = "vmmClusterCtrlrP"
  content = {
    name         = each.value.name
    hostOrIp     = each.value.hostname_ip
    rootContName = each.value.cluster_name
    port         = tostring(each.value.port)
  }
}

resource "aci_rest_managed" "vmmRsClusterAcc" {
  for_each   = { for cp in var.cluster_controller : cp.name => cp if cp.credentials != null }
  dn         = "${aci_rest_managed.vmmClusterCtrlrP[each.value.name].dn}/rsclusterAcc"
  class_name = "vmmRsClusterAcc"
  content = {
    tDn = "uni/vmmp-Nutanix/dom-${var.name}/usracc-${each.value.credentials}"
  }
}