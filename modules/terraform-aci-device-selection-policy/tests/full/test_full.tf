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

  tenant                                                  = aci_rest_managed.fvTenant.content.name
  contract                                                = "CON1"
  service_graph_template                                  = "SGT1"
  sgt_device_name                                         = "DEV1"
  consumer_l3_destination                                 = true
  consumer_permit_logging                                 = true
  consumer_logical_interface                              = "INT1"
  consumer_redirect_policy                                = "REDIR1"
  consumer_bridge_domain                                  = "BD1"
  consumer_service_epg_policy                             = "SEPGP1"
  consumer_custom_qos_policy                              = "QOSP1"
  provider_l3_destination                                 = true
  provider_permit_logging                                 = true
  provider_logical_interface                              = "INT2"
  provider_external_endpoint_group                        = "EXTEPG1"
  provider_external_endpoint_group_l3out                  = "L3OUT1"
  provider_external_endpoint_group_redistribute_bgp       = true
  provider_external_endpoint_group_redistribute_ospf      = true
  provider_external_endpoint_group_redistribute_connected = true
  provider_external_endpoint_group_redistribute_static    = true
  provider_service_epg_policy                             = "SEPGP1"
  provider_custom_qos_policy                              = "QOSP1"
}

data "aci_rest_managed" "vnsLDevCtx" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/ldevCtx-c-CON1-g-SGT1-n-N1"

  depends_on = [module.main]
}

resource "test_assertions" "vnsLDevCtx" {
  component = "vnsLDevCtx"

  equal "ctrctNameOrLbl" {
    description = "ctrctNameOrLbl"
    got         = data.aci_rest_managed.vnsLDevCtx.content.ctrctNameOrLbl
    want        = "CON1"
  }

  equal "graphNameOrLbl" {
    description = "graphNameOrLbl"
    got         = data.aci_rest_managed.vnsLDevCtx.content.graphNameOrLbl
    want        = "SGT1"
  }

  equal "nodeNameOrLbl" {
    description = "nodeNameOrLbl"
    got         = data.aci_rest_managed.vnsLDevCtx.content.nodeNameOrLbl
    want        = "N1"
  }
}

data "aci_rest_managed" "vnsRsLDevCtxToLDev" {
  dn = "${data.aci_rest_managed.vnsLDevCtx.id}/rsLDevCtxToLDev"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLDevCtxToLDev" {
  component = "vnsRsLDevCtxToLDev"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLDevCtxToLDev.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/lDevVip-DEV1"
  }
}

data "aci_rest_managed" "vnsLIfCtx_consumer" {
  dn = "${data.aci_rest_managed.vnsLDevCtx.id}/lIfCtx-c-consumer"

  depends_on = [module.main]
}

resource "test_assertions" "vnsLIfCtx_consumer" {
  component = "vnsLIfCtx_consumer"

  equal "connNameOrLbl" {
    description = "connNameOrLbl"
    got         = data.aci_rest_managed.vnsLIfCtx_consumer.content.connNameOrLbl
    want        = "consumer"
  }

  equal "l3Dest" {
    description = "l3Dest"
    got         = data.aci_rest_managed.vnsLIfCtx_consumer.content.l3Dest
    want        = "yes"
  }

  equal "permitLog" {
    description = "permitLog"
    got         = data.aci_rest_managed.vnsLIfCtx_consumer.content.permitLog
    want        = "yes"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToSvcRedirectPol_consumer" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_consumer.id}/rsLIfCtxToSvcRedirectPol"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToSvcRedirectPol_consumer" {
  component = "vnsRsLIfCtxToSvcRedirectPol_consumer"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLIfCtxToSvcRedirectPol_consumer.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/svcCont/svcRedirectPol-REDIR1"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToBD_consumer" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_consumer.id}/rsLIfCtxToBD"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToBD_consumer" {
  component = "vnsRsLIfCtxToBD_consumer"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLIfCtxToBD_consumer.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/BD-BD1"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToLIf_consumer" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_consumer.id}/rsLIfCtxToLIf"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToLIf_consumer" {
  component = "vnsRsLIfCtxToLIf_consumer"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLIfCtxToLIf_consumer.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/lDevVip-DEV1/lIf-INT1"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_consumer" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_consumer.id}/rsLIfCtxToSvcEPgPol"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToSvcEPgPol_consumer" {
  component = "vnsRsLIfCtxToSvcEPgPol_consumer"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLIfCtxToSvcEPgPol_consumer.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/svcCont/svcEPgPol-SEPGP1"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_consumer" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_consumer.id}/rsLIfCtxToCustQosPol"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToCustQosPol_consumer" {
  component = "vnsRsLIfCtxToCustQosPol_consumer"

  equal "tnQosCustomPolName" {
    description = "tnQosCustomPolName"
    got         = data.aci_rest_managed.vnsRsLIfCtxToCustQosPol_consumer.content.tnQosCustomPolName
    want        = "QOSP1"
  }
}

data "aci_rest_managed" "vnsLIfCtx_provider" {
  dn = "${data.aci_rest_managed.vnsLDevCtx.id}/lIfCtx-c-provider"

  depends_on = [module.main]
}

resource "test_assertions" "vnsLIfCtx_provider" {
  component = "vnsLIfCtx_provider"

  equal "connNameOrLbl" {
    description = "connNameOrLbl"
    got         = data.aci_rest_managed.vnsLIfCtx_provider.content.connNameOrLbl
    want        = "provider"
  }

  equal "l3Dest" {
    description = "l3Dest"
    got         = data.aci_rest_managed.vnsLIfCtx_provider.content.l3Dest
    want        = "yes"
  }

  equal "permitLog" {
    description = "permitLog"
    got         = data.aci_rest_managed.vnsLIfCtx_provider.content.permitLog
    want        = "yes"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToInstP_provider" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_provider.id}/rsLIfCtxToInstP"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToInstP_provider" {
  component = "vnsRsLIfCtxToInstP_provider"

  equal "redistribute" {
    description = "redistribute"
    got         = data.aci_rest_managed.vnsRsLIfCtxToInstP_provider.content.redistribute
    want        = "bgp,connected,ospf,static"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLIfCtxToInstP_provider.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/out-L3OUT1/instP-EXTEPG1"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToLIf_provider" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_provider.id}/rsLIfCtxToLIf"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToLIf_provider" {
  component = "vnsRsLIfCtxToLIf_provider"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLIfCtxToLIf_provider.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/lDevVip-DEV1/lIf-INT2"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToSvcEPgPol_provider" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_provider.id}/rsLIfCtxToSvcEPgPol"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToSvcEPgPol_provider" {
  component = "vnsRsLIfCtxToSvcEPgPol_provider"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsLIfCtxToSvcEPgPol_provider.content.tDn
    want        = "uni/tn-${aci_rest_managed.fvTenant.content.name}/svcCont/svcEPgPol-SEPGP1"
  }
}

data "aci_rest_managed" "vnsRsLIfCtxToCustQosPol_provider" {
  dn = "${data.aci_rest_managed.vnsLIfCtx_provider.id}/rsLIfCtxToCustQosPol"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRsLIfCtxToCustQosPol_provider" {
  component = "vnsRsLIfCtxToCustQosPol_provider"

  equal "tnQosCustomPolName" {
    description = "tnQosCustomPolName"
    got         = data.aci_rest_managed.vnsRsLIfCtxToCustQosPol_provider.content.tnQosCustomPolName
    want        = "QOSP1"
  }
}
