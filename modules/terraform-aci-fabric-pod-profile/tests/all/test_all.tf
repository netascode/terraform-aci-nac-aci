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

  name = "ALL1"
  selectors = [{
    name = "ALL1"
    type = "all"
  }]
}

data "aci_rest_managed" "fabricPodP" {
  dn = "uni/fabric/podprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodP" {
  component = "fabricPodP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodP.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "fabricPodS" {
  dn = "${data.aci_rest_managed.fabricPodP.id}/pods-ALL1-typ-ALL"

  depends_on = [module.main]
}

resource "test_assertions" "fabricPodS" {
  component = "fabricPodS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricPodS.content.name
    want        = "ALL1"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.fabricPodS.content.type
    want        = "ALL"
  }
}
