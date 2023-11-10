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

resource "aci_rest_managed" "infraAccPortP" {
  dn         = "uni/infra/accportprof-LEAF101"
  class_name = "infraAccPortP"
}

module "main" {
  source = "../.."

  interface_profile = aci_rest_managed.infraAccPortP.content.name
  name              = "1-2"
  policy_group_type = "access"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
  sub_port_blocks = [{
    name          = "SPB1"
    description   = "My Description"
    from_port     = 1
    from_sub_port = 1
    to_sub_port   = 2
  }]
}

data "aci_rest_managed" "infraHPortS" {
  dn = "uni/infra/accportprof-LEAF101/hports-${module.main.name}-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraHPortS" {
  component = "infraHPortS"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraHPortS.content.name
    want        = module.main.name
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.infraHPortS.content.type
    want        = "range"
  }
}

data "aci_rest_managed" "infraRsAccBaseGrp" {
  dn = "${data.aci_rest_managed.infraHPortS.id}/rsaccBaseGrp"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsAccBaseGrp" {
  component = "infraRsAccBaseGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.infraRsAccBaseGrp.content.tDn
    want        = "uni/infra/funcprof/accportgrp-ACC1"
  }
}

data "aci_rest_managed" "infraPortBlk" {
  dn = "${data.aci_rest_managed.infraHPortS.id}/portblk-PB1"

  depends_on = [module.main]
}

resource "test_assertions" "infraPortBlk" {
  component = "infraPortBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraPortBlk.content.name
    want        = "PB1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.infraPortBlk.content.descr
    want        = "My Description"
  }

  equal "fromCard" {
    description = "fromCard"
    got         = data.aci_rest_managed.infraPortBlk.content.fromCard
    want        = "1"
  }

  equal "toCard" {
    description = "toCard"
    got         = data.aci_rest_managed.infraPortBlk.content.toCard
    want        = "1"
  }

  equal "fromPort" {
    description = "fromPort"
    got         = data.aci_rest_managed.infraPortBlk.content.fromPort
    want        = "1"
  }

  equal "toPort" {
    description = "toPort"
    got         = data.aci_rest_managed.infraPortBlk.content.toPort
    want        = "2"
  }
}

data "aci_rest_managed" "infraSubPortBlk" {
  dn = "${data.aci_rest_managed.infraHPortS.id}/subportblk-SPB1"

  depends_on = [module.main]
}

resource "test_assertions" "infraSubPortBlk" {
  component = "infraSubPortBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.infraSubPortBlk.content.name
    want        = "SPB1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.infraSubPortBlk.content.descr
    want        = "My Description"
  }

  equal "fromCard" {
    description = "fromCard"
    got         = data.aci_rest_managed.infraSubPortBlk.content.fromCard
    want        = "1"
  }

  equal "toCard" {
    description = "toCard"
    got         = data.aci_rest_managed.infraSubPortBlk.content.toCard
    want        = "1"
  }

  equal "fromPort" {
    description = "fromPort"
    got         = data.aci_rest_managed.infraSubPortBlk.content.fromPort
    want        = "1"
  }

  equal "toPort" {
    description = "toPort"
    got         = data.aci_rest_managed.infraSubPortBlk.content.toPort
    want        = "1"
  }

  equal "fromSubPort" {
    description = "fromSubPort"
    got         = data.aci_rest_managed.infraSubPortBlk.content.fromSubPort
    want        = "1"
  }

  equal "toSubPort" {
    description = "toSubPort"
    got         = data.aci_rest_managed.infraSubPortBlk.content.toSubPort
    want        = "2"
  }
}
