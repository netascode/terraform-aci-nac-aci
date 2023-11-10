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

  name            = "EXP1"
  description     = "My Description"
  format          = "xml"
  snapshot        = true
  remote_location = "REMOTE1"
  scheduler       = "SCHEDULER1"
}

data "aci_rest_managed" "configExportP" {
  dn = "uni/fabric/configexp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "configExportP" {
  component = "configExportP"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.configExportP.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.configExportP.content.descr
    want        = "My Description"
  }

  equal "format" {
    description = "format"
    got         = data.aci_rest_managed.configExportP.content.format
    want        = "xml"
  }

  equal "snapshot" {
    description = "snapshot"
    got         = data.aci_rest_managed.configExportP.content.snapshot
    want        = "yes"
  }
}

data "aci_rest_managed" "configRsRemotePath" {
  dn = "${data.aci_rest_managed.configExportP.id}/rsRemotePath"

  depends_on = [module.main]
}

resource "test_assertions" "configRsRemotePath" {
  component = "configRsRemotePath"

  equal "tnFileRemotePathName" {
    description = "tnFileRemotePathName"
    got         = data.aci_rest_managed.configRsRemotePath.content.tnFileRemotePathName
    want        = "REMOTE1"
  }
}

data "aci_rest_managed" "configRsExportScheduler" {
  dn = "${data.aci_rest_managed.configExportP.id}/rsExportScheduler"

  depends_on = [module.main]
}

resource "test_assertions" "configRsExportScheduler" {
  component = "configRsExportScheduler"

  equal "tnTrigSchedPName" {
    description = "tnTrigSchedPName"
    got         = data.aci_rest_managed.configRsExportScheduler.content.tnTrigSchedPName
    want        = "SCHEDULER1"
  }
}
