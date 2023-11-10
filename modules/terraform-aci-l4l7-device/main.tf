locals {
  concrete_dev_ifaces = flatten([
    for device in var.concrete_devices : [
      for interface in lookup(device, "interfaces", []) : {
        id        = "${device.name}-${interface.name}"
        device    = device.name
        interface = interface.name
        alias     = interface.alias
        vnic_name = interface.vnic_name
        pod_id    = interface.pod_id
        node_id   = interface.node_id
        node2_id  = interface.node2_id
        fex_id    = interface.fex_id
        module    = interface.module
        port      = interface.port
        channel   = interface.channel
      }
    ]
  ])

  logical_iface_concrete_iface = flatten([
    for logical_iface in var.logical_interfaces : [
      for concrete_iface in lookup(logical_iface, "concrete_interfaces", []) : {
        id             = "${logical_iface.name}-${concrete_iface.interface}"
        logical_iface  = logical_iface.name
        concrete_iface = concrete_iface.interface
        device         = concrete_iface.device
      }
    ]
  ])
}

resource "aci_rest_managed" "vnsLDevVip" {
  dn         = "uni/tn-${var.tenant}/lDevVip-${var.name}"
  class_name = "vnsLDevVip"
  content = {
    contextAware = var.context_aware
    devtype      = var.type
    funcType     = var.function
    isCopy       = var.copy_device == true ? "yes" : "no"
    managed      = var.managed == true ? "yes" : "no"
    mode         = "legacy-Mode"
    name         = var.name
    nameAlias    = var.alias
    packageModel = ""
    promMode     = var.promiscuous_mode == true ? "yes" : "no"
    svcType      = var.service_type
    trunking     = var.trunking == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsALDevToPhysDomP" {
  count      = var.type == "PHYSICAL" && var.physical_domain != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLDevVip.dn}/rsALDevToPhysDomP"
  class_name = "vnsRsALDevToPhysDomP"
  content = {
    tDn = "uni/phys-${var.physical_domain}"
  }
}

resource "aci_rest_managed" "vnsRsALDevToDomP" {
  count      = var.type == "VIRTUAL" && var.vmm_domain != "" ? 1 : 0
  dn         = "${aci_rest_managed.vnsLDevVip.dn}/rsALDevToDomP"
  class_name = "vnsRsALDevToDomP"
  content = {
    tDn = "uni/vmmp-${var.vmm_provider}/dom-${var.vmm_domain}"
  }
}

resource "aci_rest_managed" "vnsCDev" {
  for_each   = { for device in var.concrete_devices : device.name => device }
  dn         = "${aci_rest_managed.vnsLDevVip.dn}/cDev-${each.value.name}"
  class_name = "vnsCDev"
  content = {
    cloneCount       = "0"
    devCtxLbl        = ""
    host             = ""
    isCloneOperation = "no"
    isTemplate       = "no"
    name             = each.value.name
    nameAlias        = each.value.alias
    vcenterName      = each.value.vcenter_name
    vmName           = each.value.vm_name
  }
}

resource "aci_rest_managed" "vnsCIf" {
  for_each   = { for interface in local.concrete_dev_ifaces : interface.id => interface }
  dn         = "${aci_rest_managed.vnsCDev[each.value.device].dn}/cIf-[${each.value.interface}]"
  class_name = "vnsCIf"
  content = {
    name      = each.value.interface
    nameAlias = each.value.alias
    vnicName  = each.value.vnic_name
  }
}

resource "aci_rest_managed" "vnsRsCIfPathAtt_port" {
  for_each   = { for interface in local.concrete_dev_ifaces : interface.id => interface if interface.port != null && interface.node_id != null && interface.channel == null }
  dn         = "${aci_rest_managed.vnsCIf["${each.value.device}-${each.value.interface}"].dn}/rsCIfPathAtt"
  class_name = "vnsRsCIfPathAtt"
  content = {
    tDn = format(each.value.fex_id != null ? "topology/pod-%s/paths-%s/extpaths-${each.value.fex_id}/pathep-[eth%s/%s]" : "topology/pod-%s/paths-%s/pathep-[eth%s/%s]", each.value.pod_id, each.value.node_id, each.value.module, each.value.port)
  }
}

resource "aci_rest_managed" "vnsRsCIfPathAtt_channel" {
  for_each   = { for interface in local.concrete_dev_ifaces : interface.id => interface if interface.channel != null && interface.node_id != null && interface.port == null }
  dn         = "${aci_rest_managed.vnsCIf["${each.value.device}-${each.value.interface}"].dn}/rsCIfPathAtt"
  class_name = "vnsRsCIfPathAtt"
  content = {
    tDn = format(each.value.node2_id != null ? "topology/pod-%s/protpaths-%s-%s/pathep-[%s]" : "topology/pod-%s/paths-%s/pathep-[%[4]s]", each.value.pod_id, each.value.node_id, each.value.node2_id, each.value.channel)
  }
}

resource "aci_rest_managed" "vnsLIf" {
  for_each   = { for logical_iface in var.logical_interfaces : logical_iface.name => logical_iface }
  dn         = "${aci_rest_managed.vnsLDevVip.dn}/lIf-${each.value.name}"
  class_name = "vnsLIf"
  content = {
    encap     = each.value.vlan != null ? "vlan-${each.value.vlan}" : "unknown"
    name      = each.value.name
    nameAlias = each.value.alias
  }
}
resource "aci_rest_managed" "vnsRsCIfAttN" {
  for_each   = { for concrete_iface in local.logical_iface_concrete_iface : concrete_iface.id => concrete_iface }
  dn         = "${aci_rest_managed.vnsLIf[each.value.logical_iface].dn}/rscIfAttN-[${aci_rest_managed.vnsCIf["${each.value.device}-${each.value.concrete_iface}"].dn}]"
  class_name = "vnsRsCIfAttN"
  content = {
    tDn = aci_rest_managed.vnsCIf["${each.value.device}-${each.value.concrete_iface}"].dn
  }
}
