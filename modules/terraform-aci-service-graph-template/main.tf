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
  count      = var.device_copy ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsNode.dn}/AbsFConn-provider"
  class_name = "vnsAbsFuncConn"
  annotation = var.annotation
  content = {
    attNotify = "no"
    name      = "provider"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Consumer" {
  count      = var.device_copy ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsNode.dn}/AbsFConn-consumer"
  class_name = "vnsAbsFuncConn"
  annotation = var.annotation
  content = {
    attNotify = "no"
    name      = "consumer"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Copy" {
  count      = var.device_copy ? 1 : 0
  dn         = "${aci_rest_managed.vnsAbsNode.dn}/AbsFConn-copy"
  class_name = "vnsAbsFuncConn"
  content = {
    attNotify = "no"
    name      = "copy"
  }
}

resource "aci_rest_managed" "vnsRsNodeToLDev" {
  dn         = "${aci_rest_managed.vnsAbsNode.dn}/rsNodeToLDev"
  class_name = "vnsRsNodeToLDev"
  annotation = var.annotation != null ? "" : null
  content = {
    tDn = try(var.device_tenant, var.tenant) == var.tenant ? "uni/tn-${var.tenant}/lDevVip-${var.device_name}" : "uni/tn-${var.tenant}/lDevIf-[uni/tn-${var.device_tenant}/lDevVip-${var.device_name}]"
  }
}

resource "aci_rest_managed" "vnsAbsConnection_Consumer" {
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsConnection-C1"
  class_name = "vnsAbsConnection"
  annotation = var.annotation
  content = {
    adjType       = var.device_copy == true ? "L2" : "L3"
    connDir       = "provider"
    connType      = "external"
    directConnect = var.consumer_direct_connect ? "yes" : "no"
    name          = "C1"
    unicastRoute  = "yes"
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT1" {
  count      = var.device_copy ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T1.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T1.dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  count      = var.device_copy ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsFuncConn_Consumer[0].dn}]" # index added
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Consumer[0].dn
  }
}

resource "aci_rest_managed" "vnsAbsConnection_Provider" {
  count      = var.device_copy ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsConnection-C2"
  class_name = "vnsAbsConnection"
  annotation = var.annotation
  content = {
    adjType       = "L3"
    connDir       = "provider"
    connType      = "external"
    directConnect = var.provider_direct_connect ? "yes" : "no"
    name          = "C2"
    unicastRoute  = "yes"
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT2" {
  count      = var.device_copy ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsConnection_Provider[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T2.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T2.dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Provider" {
  count      = var.device_copy ? 0 : 1
  dn         = "${aci_rest_managed.vnsAbsConnection_Provider[0].dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsFuncConn_Provider[0].dn}]" # index added
  class_name = "vnsRsAbsConnectionConns"
  annotation = var.annotation
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Provider[0].dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConCP1" {
  count      = var.device_copy ? 1 : 0
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer.dn}/rsabsCopyConnection-[${aci_rest_managed.vnsAbsFuncConn_Copy[0].dn}]"
  class_name = "vnsRsAbsCopyConnection"
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Copy[0].dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT1CP" {
  count      = var.device_copy ? 1 : 0
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T1.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T1.dn
  }
  depends_on = [
    aci_rest_managed.vnsRsAbsConnectionConns_ConCP1
  ]
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT2CP" {
  count      = var.device_copy ? 1 : 0
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T2.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T2.dn
  }
  depends_on = [
    aci_rest_managed.vnsRsAbsConnectionConns_ConCP1
  ]
}