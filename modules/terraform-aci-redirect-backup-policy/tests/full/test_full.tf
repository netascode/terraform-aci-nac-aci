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

  tenant      = aci_rest_managed.fvTenant.content.name
  name        = "RBP1"
  description = "My Description"
  l3_destinations = [{
    name                  = "DEST1"
    description           = "L3 description"
    ip                    = "1.1.1.1"
    ip_2                  = "1.1.1.2"
    mac                   = "00:01:02:03:04:05"
    redirect_health_group = "TEST"
  }]
}

data "aci_rest_managed" "vnsBackupPol" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "vnsBackupPol" {
  component = "vnsBackupPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.vnsBackupPol.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.vnsBackupPol.content.descr
    want        = "My Description"
  }
}
data "aci_rest_managed" "vnsRedirectDest" {
  dn = "${data.aci_rest_managed.vnsBackupPol.id}/RedirectDest_ip-[1.1.1.1]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRedirectDest" {
  component = "vnsRedirectDest"

  equal "destName" {
    description = "destName"
    got         = data.aci_rest_managed.vnsRedirectDest.content.destName
    want        = "DEST1"
  }

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
