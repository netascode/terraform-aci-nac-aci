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

  name               = "AAEP1"
  infra_vlan         = 4
  physical_domains   = ["PD1"]
  routed_domains     = ["RD1"]
  vmware_vmm_domains = ["VMM1"]
  endpoint_groups = [
    {
      tenant               = "TF"
      application_profile  = "AP1"
      endpoint_group       = "EPG1"
      primary_vlan         = 10
      secondary_vlan       = 20
      mode                 = "untagged"
      deployment_immediacy = "immediate"
    }
  ]
}

locals {
  domains = ["uni/phys-PD1", "uni/l3dom-RD1", "uni/vmmp-VMware/dom-VMM1"]
}

data "aci_rest_managed" "infraAttEntityP" {
  dn = "uni/infra/attentp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraAttEntityP" {
  component = "infraAttEntityP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraAttEntityP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "infraRsDomP" {
  for_each = toset(local.domains)
  dn       = "${data.aci_rest_managed.infraAttEntityP.id}/rsdomP-[${each.value}]"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsDomP" {
  for_each  = toset(local.domains)
  component = "infraRsDomP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsDomP[each.value].content.tDn
    want        = each.value
  }
}

data "aci_rest_managed" "infraProvAcc" {
  dn = "${data.aci_rest_managed.infraAttEntityP.id}/provacc"

  depends_on = [module.main]
}

resource "test_assertions" "infraProvAcc" {
  component = "infraProvAcc"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraProvAcc.content.name
    want        = "provacc"
  }
}

data "aci_rest_managed" "infraRsFuncToEpg" {
  dn = "${data.aci_rest_managed.infraProvAcc.id}/rsfuncToEpg-[uni/tn-infra/ap-access/epg-default]"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsFuncToEpg" {
  component = "infraRsFuncToEpg"

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.infraRsFuncToEpg.content.encap
    want        = "vlan-4"
  }

  equal "instrImedcy" {
    description = "instrImedcy"
    got         = data.aci_rest_managed.infraRsFuncToEpg.content.instrImedcy
    want        = "lazy"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.infraRsFuncToEpg.content.mode
    want        = "regular"
  }

  equal "primaryEncap" {
    description = "primaryEncap"
    got         = data.aci_rest_managed.infraRsFuncToEpg.content.primaryEncap
    want        = "unknown"
  }

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsFuncToEpg.content.tDn
    want        = "uni/tn-infra/ap-access/epg-default"
  }
}

data "aci_rest_managed" "dhcpInfraProvP" {
  dn = "${data.aci_rest_managed.infraProvAcc.id}/infraprovp"

  depends_on = [module.main]
}

resource "test_assertions" "dhcpInfraProvP" {
  component = "dhcpInfraProvP"

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.dhcpInfraProvP.content.mode
    want        = "controller"
  }
}

data "aci_rest_managed" "infraGeneric" {
  dn = "${data.aci_rest_managed.infraAttEntityP.id}/gen-default"

  depends_on = [module.main]
}

resource "test_assertions" "infraGeneric" {
  component = "infraGeneric"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraGeneric.content.name
    want        = "default"
  }
}

data "aci_rest_managed" "infraGeneric-infraRsFuncToEpg" {
  dn = "${data.aci_rest_managed.infraGeneric.id}/rsfuncToEpg-[uni/tn-TF/ap-AP1/epg-EPG1]"

  depends_on = [module.main]
}

resource "test_assertions" "infraGeneric-infraRsFuncToEpg" {
  component = "infraGeneric-infraRsFuncToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraGeneric-infraRsFuncToEpg.content.tDn
    want        = "uni/tn-TF/ap-AP1/epg-EPG1"
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.infraGeneric-infraRsFuncToEpg.content.encap
    want        = "vlan-20"
  }

  equal "primaryEncap" {
    description = "primaryEncap"
    got         = data.aci_rest_managed.infraGeneric-infraRsFuncToEpg.content.primaryEncap
    want        = "vlan-10"
  }

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.infraGeneric-infraRsFuncToEpg.content.mode
    want        = "untagged"
  }

  equal "instrImedcy" {
    description = "instrImedcy"
    got         = data.aci_rest_managed.infraGeneric-infraRsFuncToEpg.content.instrImedcy
    want        = "immediate"
  }
}
