terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant              = aci_rest_managed.fvTenant.content.name
  name                = "SGT1"
  alias               = "SGT1-ALIAS"
  description         = "My Description"
  template_type       = "FW_ROUTED"
  redirect            = true
  share_encapsulation = true
  device_name         = "DEV1"
  device_tenant       = "DEF"
  device_function     = "GoThrough"
  device_copy         = false
  device_managed      = false
}

data "aci_rest_managed" "vnsAbsGraph" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/AbsGraph-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsGraph" {
  component = "vnsAbsGraph"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsGraph.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vnsAbsGraph.content.descr
    want        = "My Description"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vnsAbsGraph.content.nameAlias
    want        = "SGT1-ALIAS"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.vnsAbsGraph.content.type
    want        = "legacy"
  }

  equal "uiTemplateType" {
    description = "uiTemplateType"
    got         = data.aci_rest_managed.vnsAbsGraph.content.uiTemplateType
    want        = "UNSPECIFIED"
  }
}

data "aci_rest_managed" "vnsAbsTermNodeCon" {
  dn = "${data.aci_rest_managed.vnsAbsGraph.id}/AbsTermNodeCon-T1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermNodeCon" {
  component = "vnsAbsTermNodeCon"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsTermNodeCon.content.name
    want        = "T1"
  }
}

data "aci_rest_managed" "vnsAbsTermConn_T1" {
  dn = "${data.aci_rest_managed.vnsAbsTermNodeCon.id}/AbsTConn"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermConn_T1" {
  component = "vnsAbsTermConn_T1"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsTermConn_T1.content.name
    want        = "1"
  }
}

data "aci_rest_managed" "vnsAbsTermNodeProv" {
  dn = "${data.aci_rest_managed.vnsAbsGraph.id}/AbsTermNodeProv-T2"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermNodeProv" {
  component = "vnsAbsTermNodeProv"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsTermNodeProv.content.name
    want        = "T2"
  }
}

data "aci_rest_managed" "vnsAbsTermConn_T2" {
  dn = "${data.aci_rest_managed.vnsAbsTermNodeProv.id}/AbsTConn"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsTermConn_T2" {
  component = "vnsAbsTermConn_T2"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsTermConn_T2.content.name
    want        = "1"
  }
}

data "aci_rest_managed" "vnsAbsNode" {
  dn = "${data.aci_rest_managed.vnsAbsGraph.id}/AbsNode-N1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsNode" {
  component = "vnsAbsNode"

  equal "funcTemplateType" {
    description = "funcTemplateType"
    got         = data.aci_rest_managed.vnsAbsNode.content.funcTemplateType
    want        = "FW_ROUTED"
  }


  equal "funcType" {
    description = "funcType"
    got         = data.aci_rest_managed.vnsAbsNode.content.funcType
    want        = "GoThrough"
  }

  equal "isCopy" {
    description = "isCopy"
    got         = data.aci_rest_managed.vnsAbsNode.content.isCopy
    want        = "no"
  }

  equal "managed" {
    description = "managed"
    got         = data.aci_rest_managed.vnsAbsNode.content.managed
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsNode.content.name
    want        = "N1"
  }

  equal "routingMode" {
    description = "routingMode"
    got         = data.aci_rest_managed.vnsAbsNode.content.routingMode
    want        = "Redirect"
  }

  equal "sequenceNumber" {
    description = "sequenceNumber"
    got         = data.aci_rest_managed.vnsAbsNode.content.sequenceNumber
    want        = "0"
  }

  equal "shareEncap" {
    description = "shareEncap"
    got         = data.aci_rest_managed.vnsAbsNode.content.shareEncap
    want        = "yes"
  }
}

data "aci_rest_managed" "vnsAbsFuncConn_Provider" {
  dn = "${data.aci_rest_managed.vnsAbsNode.id}/AbsFConn-provider"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsFuncConn_Provider" {
  component = "vnsAbsFuncConn_Provider"

  equal "attNotify" {
    description = "attNotify"
    got         = data.aci_rest_managed.vnsAbsFuncConn_Provider.content.attNotify
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsFuncConn_Provider.content.name
    want        = "provider"
  }
}

data "aci_rest_managed" "vnsAbsFuncConn_Consumer" {
  dn = "${data.aci_rest_managed.vnsAbsNode.id}/AbsFConn-consumer"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsFuncConn_Consumer" {
  component = "vnsAbsFuncConn_Consumer"

  equal "attNotify" {
    description = "attNotify"
    got         = data.aci_rest_managed.vnsAbsFuncConn_Consumer.content.attNotify
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsFuncConn_Consumer.content.name
    want        = "consumer"
  }
}

data "aci_rest_managed" "vnsRsNodeToLDev" {
  dn = "${data.aci_rest_managed.vnsAbsNode.id}/rsNodeToLDev"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsNodeToLDev" {
  component = "vnsRsNodeToLDev"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsNodeToLDev.content.tDn
    want        = "uni/tn-DEF/lDevVip-DEV1"
  }
}

data "aci_rest_managed" "vnsAbsConnection_Consumer" {
  dn = "${data.aci_rest_managed.vnsAbsGraph.id}/AbsConnection-C1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsConnection_Consumer" {
  component = "vnsAbsConnection_Consumer"

  equal "adjType" {
    description = "adjType"
    got         = data.aci_rest_managed.vnsAbsConnection_Consumer.content.adjType
    want        = "L3"
  }

  equal "connDir" {
    description = "connDir"
    got         = data.aci_rest_managed.vnsAbsConnection_Consumer.content.connDir
    want        = "provider"
  }

  equal "connType" {
    description = "connType"
    got         = data.aci_rest_managed.vnsAbsConnection_Consumer.content.connType
    want        = "external"
  }

  equal "directConnect" {
    description = "directConnect"
    got         = data.aci_rest_managed.vnsAbsConnection_Consumer.content.directConnect
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsConnection_Consumer.content.name
    want        = "C1"
  }

  equal "unicastRoute" {
    description = "unicastRoute"
    got         = data.aci_rest_managed.vnsAbsConnection_Consumer.content.unicastRoute
    want        = "yes"
  }
}

data "aci_rest_managed" "vnsRsAbsConnectionConns_ConT1" {
  dn = "${data.aci_rest_managed.vnsAbsConnection_Consumer.id}/rsabsConnectionConns-[${data.aci_rest_managed.vnsAbsTermConn_T1.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_ConT1" {
  component = "vnsRsAbsConnectionConns_ConT1"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsAbsConnectionConns_ConT1.content.tDn
    want        = data.aci_rest_managed.vnsAbsTermConn_T1.id
  }
}

data "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  dn = "${data.aci_rest_managed.vnsAbsConnection_Consumer.id}/rsabsConnectionConns-[${data.aci_rest_managed.vnsAbsFuncConn_Consumer.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_NodeN1Consumer" {
  component = "vnsRsAbsConnectionConns_NodeN1Consumer"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsAbsConnectionConns_NodeN1Consumer.content.tDn
    want        = data.aci_rest_managed.vnsAbsFuncConn_Consumer.id
  }
}

data "aci_rest_managed" "vnsAbsConnection_Provider" {
  dn = "${data.aci_rest_managed.vnsAbsGraph.id}/AbsConnection-C2"

  depends_on = [module.main]
}

resource "test_assertions" "vnsAbsConnection_Provider" {
  component = "vnsAbsConnection_Provider"

  equal "adjType" {
    description = "adjType"
    got         = data.aci_rest_managed.vnsAbsConnection_Provider.content.adjType
    want        = "L3"
  }

  equal "connDir" {
    description = "connDir"
    got         = data.aci_rest_managed.vnsAbsConnection_Provider.content.connDir
    want        = "provider"
  }

  equal "connType" {
    description = "connType"
    got         = data.aci_rest_managed.vnsAbsConnection_Provider.content.connType
    want        = "external"
  }

  equal "directConnect" {
    description = "directConnect"
    got         = data.aci_rest_managed.vnsAbsConnection_Provider.content.directConnect
    want        = "no"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsAbsConnection_Provider.content.name
    want        = "C2"
  }

  equal "unicastRoute" {
    description = "unicastRoute"
    got         = data.aci_rest_managed.vnsAbsConnection_Provider.content.unicastRoute
    want        = "yes"
  }
}

data "aci_rest_managed" "vnsRsAbsConnectionConns_ConT2" {
  dn = "${data.aci_rest_managed.vnsAbsConnection_Provider.id}/rsabsConnectionConns-[${data.aci_rest_managed.vnsAbsTermConn_T2.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_ConT2" {
  component = "vnsRsAbsConnectionConns_ConT2"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsAbsConnectionConns_ConT2.content.tDn
    want        = data.aci_rest_managed.vnsAbsTermConn_T2.id
  }
}

data "aci_rest_managed" "vnsRsAbsConnectionConns_NodeN1Provider" {
  dn = "${data.aci_rest_managed.vnsAbsConnection_Provider.id}/rsabsConnectionConns-[${data.aci_rest_managed.vnsAbsFuncConn_Provider.id}]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsAbsConnectionConns_NodeN1Provider" {
  component = "vnsRsAbsConnectionConns_NodeN1Provider"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsAbsConnectionConns_NodeN1Provider.content.tDn
    want        = data.aci_rest_managed.vnsAbsFuncConn_Provider.id
  }
}
