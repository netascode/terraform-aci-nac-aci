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

  name                       = "SC1"
  alias                      = "SC1-ALIAS"
  description                = "My Description"
  action                     = "shutdown"
  broadcast_burst_pps        = "1000"
  broadcast_burst_rate       = "10.000000"
  broadcast_pps              = "1000"
  broadcast_rate             = "10.000000"
  multicast_burst_pps        = "1000"
  multicast_burst_rate       = "10.000000"
  multicast_pps              = "1000"
  multicast_rate             = "10.000000"
  unknown_unicast_burst_pps  = "1000"
  unknown_unicast_burst_rate = "10.000000"
  unknown_unicast_pps        = "1000"
  unknown_unicast_rate       = "10.000000"
}

data "aci_rest_managed" "stormctrlIfPol" {
  dn = "uni/infra/stormctrlifp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "stormctrlIfPol" {
  component = "stormctrlIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.stormctrlIfPol.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.stormctrlIfPol.content.nameAlias
    want        = "SC1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.stormctrlIfPol.content.descr
    want        = "My Description"
  }

  equal "stormCtrlAction" {
    description = "stormCtrlAction"
    got         = data.aci_rest_managed.stormctrlIfPol.content.stormCtrlAction
    want        = "shutdown"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest_managed.stormctrlIfPol.content.type
    want        = "all"
  }

  equal "isUcMcBcStormPktCfgValid" {
    description = "isUcMcBcStormPktCfgValid"
    got         = data.aci_rest_managed.stormctrlIfPol.content.isUcMcBcStormPktCfgValid
    want        = "Valid"
  }

  equal "burstPps" {
    description = "burstPps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.burstPps
    want        = "unspecified"
  }

  equal "burstRate" {
    description = "burstRate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.burstRate
    want        = "100.000000"
  }

  equal "rate" {
    description = "rate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.rate
    want        = "100.000000"
  }

  equal "ratePps" {
    description = "ratePps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.ratePps
    want        = "unspecified"
  }

  equal "stormCtrlSoakInstCount" {
    description = "stormCtrlSoakInstCount"
    got         = data.aci_rest_managed.stormctrlIfPol.content.stormCtrlSoakInstCount
    want        = "3"
  }

  equal "bcBurstPps" {
    description = "bcBurstPps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.bcBurstPps
    want        = "1000"
  }

  equal "bcBurstRate" {
    description = "bcBurstRate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.bcBurstRate
    want        = "10.000000"
  }

  equal "bcRatePps" {
    description = "bcRatePps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.bcRatePps
    want        = "1000"
  }

  equal "bcRate" {
    description = "bcRate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.bcRate
    want        = "10.000000"
  }

  equal "mcBurstPps" {
    description = "mcBurstPps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.mcBurstPps
    want        = "1000"
  }

  equal "mcBurstRate" {
    description = "mcBurstRate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.mcBurstRate
    want        = "10.000000"
  }

  equal "mcRatePps" {
    description = "mcRatePps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.mcRatePps
    want        = "1000"
  }

  equal "mcRate" {
    description = "mcRate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.mcRate
    want        = "10.000000"
  }

  equal "uucBurstPps" {
    description = "uucBurstPps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.uucBurstPps
    want        = "1000"
  }

  equal "uucBurstRate" {
    description = "uucBurstRate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.uucBurstRate
    want        = "10.000000"
  }

  equal "uucRatePps" {
    description = "uucRatePps"
    got         = data.aci_rest_managed.stormctrlIfPol.content.uucRatePps
    want        = "1000"
  }

  equal "uucRate" {
    description = "uucRate"
    got         = data.aci_rest_managed.stormctrlIfPol.content.uucRate
    want        = "10.000000"
  }
}
