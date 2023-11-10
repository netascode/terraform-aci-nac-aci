terraform {
  required_version = ">= 1.3.0"

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

module "main" {
  source = "../.."

  name      = "VMW1"
  vlan_pool = "VP1"
}

data "aci_rest_managed" "vmmDomP" {
  dn = "uni/vmmp-VMware/dom-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "vmmDomP" {
  component = "vmmDomP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vmmDomP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "infraRsVlanNs" {
  dn = "${data.aci_rest_managed.vmmDomP.id}/rsvlanNs"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsVlanNs" {
  component = "infraRsVlanNs"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsVlanNs.content.tDn
    want        = "uni/infra/vlanns-[VP1]-dynamic"
  }
}
