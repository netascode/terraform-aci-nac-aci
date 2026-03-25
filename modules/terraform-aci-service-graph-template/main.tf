locals {
  multi_device_mode = length(var.devices) > 0

  devices_map = {
    for idx, device in var.devices : coalesce(device.node_name, device.name) => {
      index         = idx
      name          = device.name
      tenant        = coalesce(device.tenant, var.tenant)
      node_name     = coalesce(device.node_name, device.name)
      template_type = device.template_type
      function      = device.function
      copy_device   = device.copy_device
      managed       = device.managed
    }
  }

  connections_map = {
    for idx, conn in var.connections : "C${idx + 1}" => {
      index          = idx
      name           = "C${idx + 1}"
      consumer_node  = conn.consumer_node
      provider_node  = conn.provider_node
      copy_node      = conn.copy_node
      adjacency_type = coalesce(conn.adjacency_type, "L2")
      unicast_route  = coalesce(conn.unicast_route, true)
      direct_connect = coalesce(conn.direct_connect, false)
      # Resolve node references: first try devices_map (keyed by node_name), then search by device name
      resolved_consumer_node = conn.consumer_node == "EPG-Consumer" ? "EPG-Consumer" : try(
        local.devices_map[conn.consumer_node].node_name,
        [for d in var.devices : coalesce(d.node_name, d.name) if d.name == conn.consumer_node][0],
        conn.consumer_node
      )
      resolved_provider_node = conn.provider_node == "EPG-Provider" ? "EPG-Provider" : try(
        local.devices_map[conn.provider_node].node_name,
        [for d in var.devices : coalesce(d.node_name, d.name) if d.name == conn.provider_node][0],
        conn.provider_node
      )
      resolved_copy_node = conn.copy_node != null ? try(
        local.devices_map[conn.copy_node].node_name,
        [for d in var.devices : coalesce(d.node_name, d.name) if d.name == conn.copy_node][0],
        conn.copy_node
      ) : null
    }
  }
}

resource "aci_rest_managed" "vnsAbsGraph" {
  dn         = "uni/tn-${var.tenant}/AbsGraph-${var.name}"
  class_name = "vnsAbsGraph"
  annotation = var.annotation
  content = {
    name           = var.name
    descr          = var.description
    nameAlias      = var.alias
    type           = "legacy"
    uiTemplateType = "UNSPECIFIED"
  }
}

resource "aci_rest_managed" "vnsAbsTermNodeCon" {
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsTermNodeCon-T1"
  class_name = "vnsAbsTermNodeCon"
  annotation = var.annotation
  content = {
    name = "T1"
  }
}

resource "aci_rest_managed" "vnsAbsTermConn_T1" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeCon.dn}/AbsTConn"
  class_name = "vnsAbsTermConn"
  annotation = var.annotation
  content = {
    name = "1"
  }
}

resource "aci_rest_managed" "vnsInTerm_T1" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeCon.dn}/intmnl"
  class_name = "vnsInTerm"
  annotation = var.annotation != null ? "" : null
}

resource "aci_rest_managed" "vnsOutTerm_T1" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeCon.dn}/outtmnl"
  class_name = "vnsOutTerm"
  annotation = var.annotation != null ? "" : null
}

resource "aci_rest_managed" "vnsAbsTermNodeProv" {
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsTermNodeProv-T2"
  class_name = "vnsAbsTermNodeProv"
  annotation = var.annotation
  content = {
    name = "T2"
  }
}

resource "aci_rest_managed" "vnsAbsTermConn_T2" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeProv.dn}/AbsTConn"
  class_name = "vnsAbsTermConn"
  annotation = var.annotation
  content = {
    name = "1"
  }
}

resource "aci_rest_managed" "vnsInTerm_T2" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeProv.dn}/intmnl"
  class_name = "vnsInTerm"
  annotation = var.annotation != null ? "" : null
}

resource "aci_rest_managed" "vnsOutTerm_T2" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeProv.dn}/outtmnl"
  class_name = "vnsOutTerm"
  annotation = var.annotation != null ? "" : null
}

resource "aci_rest_managed" "vnsAbsNode" {
  count      = local.multi_device_mode ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${var.device_node_name}"
  class_name = "vnsAbsNode"
  annotation = var.annotation
  content = {
    funcTemplateType = var.template_type
    funcType         = var.device_function != "" ? var.device_function : "GoTo"
    isCopy           = var.device_copy == true ? "yes" : "no"
    managed          = var.device_managed == true ? "yes" : "no"
    name             = var.device_node_name
    routingMode      = var.redirect == true ? "Redirect" : "unspecified"
    sequenceNumber   = "0"
    shareEncap       = var.share_encapsulation == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Provider" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 0 : 1)
  dn         = "${aci_rest_managed.vnsAbsNode[0].dn}/AbsFConn-provider"
  class_name = "vnsAbsFuncConn"
  annotation = var.annotation
  content = {
    attNotify = "no"
    name      = "provider"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Consumer" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 0 : 1)
  dn         = "${aci_rest_managed.vnsAbsNode[0].dn}/AbsFConn-consumer"
  class_name = "vnsAbsFuncConn"
  annotation = var.annotation
  content = {
    attNotify = "no"
    name      = "consumer"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Copy" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 1 : 0)
  dn         = "${aci_rest_managed.vnsAbsNode[0].dn}/AbsFConn-copy"
  class_name = "vnsAbsFuncConn"
  content = {
    attNotify = "no"
    name      = "copy"
  }
}

resource "aci_rest_managed" "vnsRsNodeToLDev" {
  count      = local.multi_device_mode ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsNode[0].dn}/rsNodeToLDev"
  class_name = "vnsRsNodeToLDev"
  annotation = var.annotation != null ? "" : null
  content = {
    tDn = try(var.device_tenant, var.tenant) == var.tenant ? "uni/tn-${var.tenant}/lDevVip-${var.device_name}" : "uni/tn-${var.tenant}/lDevIf-[uni/tn-${var.device_tenant}/lDevVip-${var.device_name}]"
  }
}

resource "aci_rest_managed" "vnsAbsConnection_Consumer" {
  count      = local.multi_device_mode ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsConnection-C1"
  class_name = "vnsAbsConnection"
  annotation = var.annotation
  content = {
    adjType       = var.device_copy == true ? "L2" : var.device_adjacency_type
    connDir       = "provider"
    connType      = "external"
    directConnect = var.consumer_direct_connect ? "yes" : "no"
    name          = "C1"
    unicastRoute  = "yes"
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT1" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 0 : 1)
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T1.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T1.dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 0 : 1)
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsFuncConn_Consumer[0].dn}]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Consumer[0].dn
  }
}

resource "aci_rest_managed" "vnsAbsConnection_Provider" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 0 : 1)
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsConnection-C2"
  class_name = "vnsAbsConnection"
  annotation = var.annotation
  content = {
    adjType       = var.device_adjacency_type
    connDir       = "provider"
    connType      = "external"
    directConnect = var.provider_direct_connect ? "yes" : "no"
    name          = "C2"
    unicastRoute  = "yes"
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT2" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 0 : 1)
  dn         = "${aci_rest_managed.vnsAbsConnection_Provider[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T2.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T2.dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Provider" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 0 : 1)
  dn         = "${aci_rest_managed.vnsAbsConnection_Provider[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsFuncConn_Provider[0].dn}]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Provider[0].dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConCP1" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 1 : 0)
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer[0].dn}/rsabsCopyConnection-[${aci_rest_managed.vnsAbsFuncConn_Copy[0].dn}]"
  class_name = "vnsRsAbsCopyConnection"
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Copy[0].dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT1CP" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 1 : 0)
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T1.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T1.dn
  }
  depends_on = [
    aci_rest_managed.vnsRsAbsConnectionConns_ConCP1
  ]
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT2CP" {
  count      = local.multi_device_mode ? 0 : (var.device_copy ? 1 : 0)
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T2.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T2.dn
  }
  depends_on = [
    aci_rest_managed.vnsRsAbsConnectionConns_ConCP1
  ]
}

resource "aci_rest_managed" "vnsAbsNode_multi" {
  for_each   = local.multi_device_mode ? local.devices_map : {}
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${each.value.node_name}"
  class_name = "vnsAbsNode"
  annotation = var.annotation
  content = {
    funcTemplateType = each.value.template_type
    funcType         = each.value.function
    isCopy           = each.value.copy_device ? "yes" : "no"
    managed          = each.value.managed ? "yes" : "no"
    name             = each.value.node_name
    routingMode      = var.redirect ? "Redirect" : "unspecified"
    sequenceNumber   = tostring(each.value.index)
    shareEncap       = var.share_encapsulation ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Provider_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if !v.copy_device } : {}
  dn         = "${aci_rest_managed.vnsAbsNode_multi[each.key].dn}/AbsFConn-provider"
  class_name = "vnsAbsFuncConn"
  annotation = var.annotation
  content = {
    attNotify = "no"
    name      = "provider"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Consumer_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if !v.copy_device } : {}
  dn         = "${aci_rest_managed.vnsAbsNode_multi[each.key].dn}/AbsFConn-consumer"
  class_name = "vnsAbsFuncConn"
  annotation = var.annotation
  content = {
    attNotify = "no"
    name      = "consumer"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Copy_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.devices_map : k => v if v.copy_device } : {}
  dn         = "${aci_rest_managed.vnsAbsNode_multi[each.key].dn}/AbsFConn-copy"
  class_name = "vnsAbsFuncConn"
  annotation = var.annotation
  content = {
    attNotify = "no"
    name      = "copy"
  }
}

resource "aci_rest_managed" "vnsRsNodeToLDev_multi" {
  for_each   = local.multi_device_mode ? local.devices_map : {}
  dn         = "${aci_rest_managed.vnsAbsNode_multi[each.key].dn}/rsNodeToLDev"
  class_name = "vnsRsNodeToLDev"
  annotation = var.annotation != null ? "" : null
  content = {
    tDn = each.value.tenant == var.tenant ? "uni/tn-${var.tenant}/lDevVip-${each.value.name}" : "uni/tn-${var.tenant}/lDevIf-[uni/tn-${each.value.tenant}/lDevVip-${each.value.name}]"
  }
}

resource "aci_rest_managed" "vnsAbsConnection_multi" {
  for_each   = local.multi_device_mode ? local.connections_map : {}
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsConnection-${each.value.name}"
  class_name = "vnsAbsConnection"
  annotation = var.annotation
  content = {
    adjType       = each.value.adjacency_type
    connDir       = "provider"
    connType      = "external"
    directConnect = each.value.direct_connect ? "yes" : "no"
    name          = each.value.name
    unicastRoute  = each.value.unicast_route ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsRsAbsCopyConnection_multi" {
  for_each   = local.multi_device_mode ? { for k, v in local.connections_map : k => v if v.copy_node != null } : {}
  dn         = "${aci_rest_managed.vnsAbsConnection_multi[each.key].dn}/rsabsCopyConnection-[${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${each.value.resolved_copy_node}/AbsFConn-copy]"
  class_name = "vnsRsAbsCopyConnection"
  annotation = var.annotation
  content = {
    tDn = "${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${each.value.resolved_copy_node}/AbsFConn-copy"
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_Consumer_multi" {
  for_each   = local.multi_device_mode ? local.connections_map : {}
  dn         = each.value.consumer_node == "EPG-Consumer" ? "${aci_rest_managed.vnsAbsConnection_multi[each.key].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T1.dn}]" : "${aci_rest_managed.vnsAbsConnection_multi[each.key].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${each.value.resolved_consumer_node}/AbsFConn-consumer]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = each.value.consumer_node == "EPG-Consumer" ? aci_rest_managed.vnsAbsTermConn_T1.dn : "${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${each.value.resolved_consumer_node}/AbsFConn-consumer"
  }
  depends_on = [
    aci_rest_managed.vnsRsAbsCopyConnection_multi
  ]
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_Provider_multi" {
  for_each   = local.multi_device_mode ? local.connections_map : {}
  dn         = each.value.provider_node == "EPG-Provider" ? "${aci_rest_managed.vnsAbsConnection_multi[each.key].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T2.dn}]" : "${aci_rest_managed.vnsAbsConnection_multi[each.key].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${each.value.resolved_provider_node}/AbsFConn-provider]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = each.value.provider_node == "EPG-Provider" ? aci_rest_managed.vnsAbsTermConn_T2.dn : "${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-${each.value.resolved_provider_node}/AbsFConn-provider"
  }
  depends_on = [
    aci_rest_managed.vnsRsAbsCopyConnection_multi
  ]
}
