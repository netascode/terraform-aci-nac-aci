terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = "=2.10.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant            = "TF"
  name              = "EIGRP1"
  description       = "My Description"
  hello_interval    = 10
  hold_interval     = 30
  bandwidth         = 10
  delay             = 20
  delay_unit        = "pico"
  bfd               = true
  self_nexthop      = true
  passive_interface = true
  split_horizon     = true
}

data "aci_rest_managed" "eigrpIfPol" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "eigrpIfPol" {
  component = "eigrpIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.eigrpIfPol.content.name
    want        = module.main.name
  }

  equal "helloIntvl" {
    description = "helloIntvl"
    got         = data.aci_rest_managed.eigrpIfPol.content.helloIntvl
    want        = "10"
  }

  equal "holdIntvl" {
    description = "holdIntvl"
    got         = data.aci_rest_managed.eigrpIfPol.content.holdIntvl
    want        = "30"
  }

  equal "bw" {
    description = "bw"
    got         = data.aci_rest_managed.eigrpIfPol.content.bw
    want        = "10"
  }

  equal "delay" {
    description = "delay"
    got         = data.aci_rest_managed.eigrpIfPol.content.delay
    want        = "20"
  }

  equal "delayUnit" {
    description = "delayUnit"
    got         = data.aci_rest_managed.eigrpIfPol.content.delayUnit
    want        = "pico"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest_managed.eigrpIfPol.content.ctrl
    want        = "bfd,nh-self,passive,split-horizon"
  }
}
