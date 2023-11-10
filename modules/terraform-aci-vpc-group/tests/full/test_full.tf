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

  mode = "explicit"
  groups = [{
    name     = "VPC101"
    id       = 101
    policy   = "VPC1"
    switch_1 = 101
    switch_2 = 102
  }]
}

data "aci_rest_managed" "fabricProtPol" {
  dn = "uni/fabric/protpol"

  depends_on = [module.main]
}

resource "test_assertions" "fabricProtPol" {
  component = "fabricProtPol"

  equal "pairT" {
    description = "pairT"
    got         = data.aci_rest_managed.fabricProtPol.content.pairT
    want        = "explicit"
  }
}

data "aci_rest_managed" "fabricExplicitGEp" {
  dn = "${data.aci_rest_managed.fabricProtPol.id}/expgep-VPC101"

  depends_on = [module.main]
}

resource "test_assertions" "fabricExplicitGEp" {
  component = "fabricExplicitGEp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fabricExplicitGEp.content.name
    want        = "VPC101"
  }

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.fabricExplicitGEp.content.id
    want        = "101"
  }
}

data "aci_rest_managed" "fabricRsVpcInstPol" {
  dn = "${data.aci_rest_managed.fabricExplicitGEp.id}/rsvpcInstPol"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsVpcInstPol" {
  component = "fabricRsVpcInstPol"

  equal "tnVpcInstPolName" {
    description = "tnVpcInstPolName"
    got         = data.aci_rest_managed.fabricRsVpcInstPol.content.tnVpcInstPolName
    want        = "VPC1"
  }
}

data "aci_rest_managed" "fabricNodePEp-1" {
  dn = "${data.aci_rest_managed.fabricExplicitGEp.id}/nodepep-101"

  depends_on = [module.main]
}

resource "test_assertions" "fabricNodePEp-1" {
  component = "fabricNodePEp-1"

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.fabricNodePEp-1.content.id
    want        = "101"
  }
}

data "aci_rest_managed" "fabricNodePEp-2" {
  dn = "${data.aci_rest_managed.fabricExplicitGEp.id}/nodepep-102"

  depends_on = [module.main]
}

resource "test_assertions" "fabricNodePEp-2" {
  component = "fabricNodePEp-2"

  equal "id" {
    description = "id"
    got         = data.aci_rest_managed.fabricNodePEp-2.content.id
    want        = "102"
  }
}
