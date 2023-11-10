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

  name        = "RL1"
  hostname_ip = "1.1.1.1"
}

data "aci_rest_managed" "fileRemotePath" {
  dn = "uni/fabric/path-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fileRemotePath" {
  component = "fileRemotePath"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fileRemotePath.content.name
    want        = module.main.name
  }

  equal "host" {
    description = "host"
    got         = data.aci_rest_managed.fileRemotePath.content.host
    want        = "1.1.1.1"
  }
}
