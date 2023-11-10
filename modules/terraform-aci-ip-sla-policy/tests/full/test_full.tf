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

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}


module "main" {
  source = "../.."

  name        = "TEST_FULL"
  description = "My IP SLA Policy"
  tenant      = aci_rest_managed.fvTenant.content.name
  multiplier  = 6
  frequency   = 123
  sla_type    = "tcp"
  port        = 123
}

data "aci_rest_managed" "fvIPSLAMonitoringPol" {
  dn = "uni/tn-${aci_rest_managed.fvTenant.content.name}/ipslaMonitoringPol-TEST_FULL"

  depends_on = [module.main]
}

resource "test_assertions" "fvIPSLAMonitoringPol" {
  component = "fvIPSLAMonitoringPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fvIPSLAMonitoringPol.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fvIPSLAMonitoringPol.content.descr
    want        = "My IP SLA Policy"
  }

  equal "slaDetectMultiplier" {
    description = "slaDetectMultiplier"
    got         = data.aci_rest_managed.fvIPSLAMonitoringPol.content.slaDetectMultiplier
    want        = "6"
  }

  equal "slaFrequency" {
    description = "slaFrequency"
    got         = data.aci_rest_managed.fvIPSLAMonitoringPol.content.slaFrequency
    want        = "123"
  }

  equal "slaType" {
    description = "descr"
    got         = data.aci_rest_managed.fvIPSLAMonitoringPol.content.slaType
    want        = "tcp"
  }

  equal "slaPort" {
    description = "slaPort"
    got         = data.aci_rest_managed.fvIPSLAMonitoringPol.content.slaPort
    want        = "123"
  }
}
