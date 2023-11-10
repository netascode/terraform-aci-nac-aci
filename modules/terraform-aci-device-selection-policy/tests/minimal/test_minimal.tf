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

  tenant                     = aci_rest_managed.fvTenant.content.name
  contract                   = "CON1"
  service_graph_template     = "SGT1"
  sgt_device_name            = "DEV1"
  consumer_logical_interface = "INT1"
  provider_logical_interface = "INT2"
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

data "aci_rest_managed" "vnsRsLIfCtxToLIf_consumer" {
  dn = "${data.aci_rest_managed.vnsLDevCtx.id}/lIfCtx-c-consumer/rsLIfCtxToLIf"

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

data "aci_rest_managed" "vnsRsLIfCtxToLIf_provider" {
  dn = "${data.aci_rest_managed.vnsLDevCtx.id}/lIfCtx-c-provider/rsLIfCtxToLIf"

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
