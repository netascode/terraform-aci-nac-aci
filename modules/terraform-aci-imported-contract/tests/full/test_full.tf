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

  tenant          = aci_rest_managed.fvTenant.content.name
  name            = "CON1"
  source_tenant   = "DEF"
  source_contract = "CON1"
}

data "aci_rest_managed" "vzCPIf" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/cif-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vzCPIf" {
  component = "vzCPIf"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vzCPIf.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "vzRsIf" {
  dn = "${data.aci_rest_managed.vzCPIf.id}/rsif"

  depends_on = [module.main]
}

resource "test_assertions" "vzRsIf" {
  component = "vzRsIf"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vzRsIf.content.tDn
    want        = "uni/tn-DEF/brc-CON1"
  }
}
