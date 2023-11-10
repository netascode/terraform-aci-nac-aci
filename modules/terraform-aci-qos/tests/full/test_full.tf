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

  preserve_cos = true
  qos_classes = [{
    level                = 1
    admin_state          = false
    mtu                  = 9000
    bandwidth_percent    = 30
    scheduling           = "strict-priority"
    congestion_algorithm = "wred"
    minimum_buffer       = 1
    pfc_state            = true
    no_drop_cos          = "cos1"
    pfc_scope            = "fabric"
    ecn                  = true
    forward_non_ecn      = true
    wred_max_threshold   = 90
    wred_min_threshold   = 10
    wred_probability     = 5
    weight               = 1
  }]
}

data "aci_rest_managed" "qosInstPol" {
  dn = "uni/infra/qosinst-default"

  depends_on = [module.main]
}

resource "test_assertions" "qosInstPol" {
  component = "qosInstPol"

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.qosInstPol.content.ctrl
    want        = "dot1p-preserve"
  }
}

data "aci_rest_managed" "qosClass" {
  dn = "uni/infra/qosinst-default/class-level1"

  depends_on = [module.main]
}

resource "test_assertions" "qosClass" {
  component = "qosClass"

  equal "prio" {
    description = "prio"
    got         = data.aci_rest_managed.qosClass.content.prio
    want        = "level1"
  }

  equal "admin" {
    description = "admin"
    got         = data.aci_rest_managed.qosClass.content.admin
    want        = "disabled"
  }

  equal "mtu" {
    description = "mtu"
    got         = data.aci_rest_managed.qosClass.content.mtu
    want        = "9000"
  }
}

data "aci_rest_managed" "qosSched" {
  dn = "${data.aci_rest_managed.qosClass.id}/sched"

  depends_on = [module.main]
}

resource "test_assertions" "qosSched" {
  component = "qosSched"

  equal "bw" {
    description = "bw"
    got         = data.aci_rest_managed.qosSched.content.bw
    want        = "30"
  }

  equal "meth" {
    description = "meth"
    got         = data.aci_rest_managed.qosSched.content.meth
    want        = "sp"
  }
}

data "aci_rest_managed" "qosQueue" {
  dn = "${data.aci_rest_managed.qosClass.id}/queue"

  depends_on = [module.main]
}

resource "test_assertions" "qosQueue" {
  component = "qosQueue"

  equal "limit" {
    description = "limit"
    got         = data.aci_rest_managed.qosQueue.content.limit
    want        = "1522"
  }

  equal "meth" {
    description = "meth"
    got         = data.aci_rest_managed.qosQueue.content.meth
    want        = "dynamic"
  }
}

data "aci_rest_managed" "qosPfcPol" {
  dn = "${data.aci_rest_managed.qosClass.id}/pfcpol-default"

  depends_on = [module.main]
}

resource "test_assertions" "qosPfcPol" {
  component = "qosPfcPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.qosPfcPol.content.name
    want        = "default"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.qosPfcPol.content.adminSt
    want        = "yes"
  }

  equal "noDropCos" {
    description = "noDropCos"
    got         = data.aci_rest_managed.qosPfcPol.content.noDropCos
    want        = "cos1"
  }

  equal "enableScope" {
    description = "enableScope"
    got         = data.aci_rest_managed.qosPfcPol.content.enableScope
    want        = "fabric"
  }
}

data "aci_rest_managed" "qosCong" {
  dn = "${data.aci_rest_managed.qosClass.id}/cong"

  depends_on = [module.main]
}

resource "test_assertions" "qosCong" {
  component = "qosCong"

  equal "afdQueueLength" {
    description = "afdQueueLength"
    got         = data.aci_rest_managed.qosCong.content.afdQueueLength
    want        = "0"
  }

  equal "algo" {
    description = "algo"
    got         = data.aci_rest_managed.qosCong.content.algo
    want        = "wred"
  }

  equal "ecn" {
    description = "ecn"
    got         = data.aci_rest_managed.qosCong.content.ecn
    want        = "enabled"
  }

  equal "forwardNonEcn" {
    description = "forwardNonEcn"
    got         = data.aci_rest_managed.qosCong.content.forwardNonEcn
    want        = "enabled"
  }

  equal "wredMaxThreshold" {
    description = "wredMaxThreshold"
    got         = data.aci_rest_managed.qosCong.content.wredMaxThreshold
    want        = "90"
  }

  equal "wredMinThreshold" {
    description = "wredMinThreshold"
    got         = data.aci_rest_managed.qosCong.content.wredMinThreshold
    want        = "10"
  }

  equal "wredProbability" {
    description = "wredProbability"
    got         = data.aci_rest_managed.qosCong.content.wredProbability
    want        = "5"
  }

  equal "wredWeight" {
    description = "wredWeight"
    got         = data.aci_rest_managed.qosCong.content.wredWeight
    want        = "1"
  }
}

data "aci_rest_managed" "qosBuffer" {
  dn = "${data.aci_rest_managed.qosClass.id}/buffer"

  depends_on = [module.main]
}

resource "test_assertions" "qosBuffer" {
  component = "qosBuffer"

  equal "min" {
    description = "min"
    got         = data.aci_rest_managed.qosBuffer.content.min
    want        = "1"
  }
}
