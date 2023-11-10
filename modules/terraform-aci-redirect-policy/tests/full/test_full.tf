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

  tenant                 = aci_rest_managed.fvTenant.content.name
  name                   = "REDIRECT1"
  alias                  = "REDIRECT1-ALIAS"
  description            = "My Description"
  anycast                = false
  type                   = "L3"
  hashing                = "sip"
  threshold              = true
  max_threshold          = 90
  min_threshold          = 10
  pod_aware              = true
  resilient_hashing      = true
  threshold_down_action  = "deny"
  ip_sla_policy          = "SLA1"
  redirect_backup_policy = "REDIRECT_BCK1"
  l3_destinations = [{
    description           = "L3 description"
    ip                    = "1.1.1.1"
    ip_2                  = "1.1.1.2"
    mac                   = "00:01:02:03:04:05"
    pod_id                = 2
    redirect_health_group = "TEST"
  }]
}

data "aci_rest_managed" "vnsSvcRedirectPol" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "vnsSvcRedirectPol" {
  component = "vnsSvcRedirectPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.nameAlias
    want        = "REDIRECT1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.descr
    want        = "My Description"
  }

  equal "AnycastEnabled" {
    description = "AnycastEnabled"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.AnycastEnabled
    want        = "no"
  }

  equal "destType" {
    description = "destType"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.destType
    want        = "L3"
  }

  equal "hashingAlgorithm" {
    description = "hashingAlgorithm"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.hashingAlgorithm
    want        = "sip"
  }

  equal "thresholdEnable" {
    description = "thresholdEnable"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.thresholdEnable
    want        = "yes"
  }

  equal "maxThresholdPercent" {
    description = "maxThresholdPercent"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.maxThresholdPercent
    want        = "90"
  }

  equal "minThresholdPercent" {
    description = "minThresholdPercent"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.minThresholdPercent
    want        = "10"
  }

  equal "programLocalPodOnly" {
    description = "programLocalPodOnly"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.programLocalPodOnly
    want        = "yes"
  }

  equal "resilientHashEnabled" {
    description = "resilientHashEnabled"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.resilientHashEnabled
    want        = "yes"
  }

  equal "thresholdDownAction" {
    description = "thresholdDownAction"
    got         = data.aci_rest_managed.vnsSvcRedirectPol.content.thresholdDownAction
    want        = "deny"
  }
}


data "aci_rest_managed" "vnsRsIPSLAMonitoringPol" {
  dn = "${data.aci_rest_managed.vnsSvcRedirectPol.id}/rsIPSLAMonitoringPol"

  depends_on = [module.main]
}


resource "test_assertions" "vnsRsIPSLAMonitoringPol" {
  component = "vnsRsIPSLAMonitoringPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsIPSLAMonitoringPol.content.tDn
    want        = "${aci_rest_managed.fvTenant.id}/ipslaMonitoringPol-SLA1"
  }
}


data "aci_rest_managed" "vnsRsBackupPol" {
  dn = "${data.aci_rest_managed.vnsSvcRedirectPol.id}/rsBackupPol"

  depends_on = [module.main]
}


resource "test_assertions" "vnsRsBackupPol" {
  component = "vnsRsBackupPol"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsBackupPol.content.tDn
    want        = "${aci_rest_managed.fvTenant.id}/svcCont/backupPol-REDIRECT_BCK1"
  }
}

data "aci_rest_managed" "vnsRedirectDest" {
  dn = "${data.aci_rest_managed.vnsSvcRedirectPol.id}/RedirectDest_ip-[1.1.1.1]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRedirectDest" {
  component = "vnsRedirectDest"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vnsRedirectDest.content.descr
    want        = "L3 description"
  }

  equal "ip" {
    description = "ip"
    got         = data.aci_rest_managed.vnsRedirectDest.content.ip
    want        = "1.1.1.1"
  }

  equal "ip2" {
    description = "ip2"
    got         = data.aci_rest_managed.vnsRedirectDest.content.ip2
    want        = "1.1.1.2"
  }

  equal "mac" {
    description = "mac"
    got         = data.aci_rest_managed.vnsRedirectDest.content.mac
    want        = "00:01:02:03:04:05"
  }

  equal "podId" {
    description = "podId"
    got         = data.aci_rest_managed.vnsRedirectDest.content.podId
    want        = "2"
  }
}

data "aci_rest_managed" "vnsRsRedirectHealthGroup" {
  dn = "${data.aci_rest_managed.vnsRedirectDest.id}/rsRedirectHealthGroup"

  depends_on = [module.main]
}


resource "test_assertions" "vnsRsRedirectHealthGroup" {
  component = "vnsRsRedirectHealthGroup"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.vnsRsRedirectHealthGroup.content.tDn
    want        = "uni/tn-TF/svcCont/redirectHealthGroup-TEST"
  }

}