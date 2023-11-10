resource "aci_rest_managed" "vnsAbsGraph" {
  dn         = "uni/tn-${var.tenant}/AbsGraph-${var.name}"
  class_name = "vnsAbsGraph"
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
  content = {
    name = "T1"
  }
}

resource "aci_rest_managed" "vnsAbsTermConn_T1" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeCon.dn}/AbsTConn"
  class_name = "vnsAbsTermConn"
  content = {
    name = "1"
  }
}

resource "aci_rest_managed" "vnsInTerm_T1" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeCon.dn}/intmnl"
  class_name = "vnsInTerm"
}

resource "aci_rest_managed" "vnsOutTerm_T1" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeCon.dn}/outtmnl"
  class_name = "vnsOutTerm"
}

resource "aci_rest_managed" "vnsAbsTermNodeProv" {
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsTermNodeProv-T2"
  class_name = "vnsAbsTermNodeProv"
  content = {
    name = "T2"
  }
}

resource "aci_rest_managed" "vnsAbsTermConn_T2" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeProv.dn}/AbsTConn"
  class_name = "vnsAbsTermConn"
  content = {
    name = "1"
  }
}

resource "aci_rest_managed" "vnsInTerm_T2" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeProv.dn}/intmnl"
  class_name = "vnsInTerm"
}

resource "aci_rest_managed" "vnsOutTerm_T2" {
  dn         = "${aci_rest_managed.vnsAbsTermNodeProv.dn}/outtmnl"
  class_name = "vnsOutTerm"
}

resource "aci_rest_managed" "vnsAbsNode" {
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsNode-N1"
  class_name = "vnsAbsNode"
  content = {
    funcTemplateType = var.template_type
    funcType         = var.device_function != "" ? var.device_function : "GoTo"
    isCopy           = var.device_copy == true ? "yes" : "no"
    managed          = var.device_managed == true ? "yes" : "no"
    name             = "N1"
    routingMode      = var.redirect == true ? "Redirect" : "unspecified"
    sequenceNumber   = "0"
    shareEncap       = var.share_encapsulation == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Provider" {
  dn         = "${aci_rest_managed.vnsAbsNode.dn}/AbsFConn-provider"
  class_name = "vnsAbsFuncConn"
  content = {
    attNotify = "no"
    name      = "provider"
  }
}

resource "aci_rest_managed" "vnsAbsFuncConn_Consumer" {
  dn         = "${aci_rest_managed.vnsAbsNode.dn}/AbsFConn-consumer"
  class_name = "vnsAbsFuncConn"
  content = {
    attNotify = "no"
    name      = "consumer"
  }
}

resource "aci_rest_managed" "vnsRsNodeToLDev" {
  dn         = "${aci_rest_managed.vnsAbsNode.dn}/rsNodeToLDev"
  class_name = "vnsRsNodeToLDev"
  content = {
    tDn = "uni/tn-${var.device_tenant != "" ? var.device_tenant : var.tenant}/lDevVip-${var.device_name}"
  }
}

resource "aci_rest_managed" "vnsAbsConnection_Consumer" {
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsConnection-C1"
  class_name = "vnsAbsConnection"
  content = {
    adjType       = "L3"
    connDir       = "provider"
    connType      = "external"
    directConnect = "no"
    name          = "C1"
    unicastRoute  = "yes"
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT1" {
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T1.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T1.dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  dn         = "${aci_rest_managed.vnsAbsConnection_Consumer.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsFuncConn_Consumer.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Consumer.dn
  }
}

resource "aci_rest_managed" "vnsAbsConnection_Provider" {
  dn         = "${aci_rest_managed.vnsAbsGraph.dn}/AbsConnection-C2"
  class_name = "vnsAbsConnection"
  content = {
    adjType       = "L3"
    connDir       = "provider"
    connType      = "external"
    directConnect = "no"
    name          = "C2"
    unicastRoute  = "yes"
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_ConT2" {
  dn         = "${aci_rest_managed.vnsAbsConnection_Provider.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsTermConn_T2.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsTermConn_T2.dn
  }
}

resource "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Provider" {
  dn         = "${aci_rest_managed.vnsAbsConnection_Provider.dn}/rsabsConnectionConns-[${aci_rest_managed.vnsAbsFuncConn_Provider.dn}]"
  class_name = "vnsRsAbsConnectionConns"
  content = {
    tDn = aci_rest_managed.vnsAbsFuncConn_Provider.dn
  }
}
