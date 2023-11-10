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

  interface_preference = "ooband"
}

data "aci_rest_managed" "mgmtConnectivityPrefs" {
  dn = "uni/fabric/connectivityPrefs"

  depends_on = [module.main]
}

resource "test_assertions" "mgmtConnectivityPrefs" {
  component = "mgmtConnectivityPrefs"

  equal "interfacePref" {
    description = "interfacePref"
    got         = data.aci_rest_managed.mgmtConnectivityPrefs.content.interfacePref
    want        = "ooband"
  }
}
