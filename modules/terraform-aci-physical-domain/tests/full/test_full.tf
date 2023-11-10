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

module "main" {
  source = "../.."

  name                 = "PHY1"
  vlan_pool            = "VP1"
  vlan_pool_allocation = "dynamic"
  security_domains     = ["SEC1"]

}

data "aci_rest_managed" "physDomP" {
  dn = "uni/phys-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "physDomP" {
  component = "physDomP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.physDomP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "infraRsVlanNs" {
  dn = "${data.aci_rest_managed.physDomP.id}/rsvlanNs"
}

resource "test_assertions" "infraRsVlanNs" {
  component = "infraRsVlanNs"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsVlanNs.content.tDn
    want        = "uni/infra/vlanns-[VP1]-dynamic"
  }
}

data "aci_rest_managed" "aaaDomainRef" {
  dn = "${data.aci_rest_managed.physDomP.dn}/domain-SEC1"

  depends_on = [module.main]
}

resource "test_assertions" "aaaDomainRef" {
  component = "aaaDomainRef"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaDomainRef.content.name
    want        = "SEC1"
  }
}
