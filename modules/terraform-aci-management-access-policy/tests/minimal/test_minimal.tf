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

  name           = "MAP1"
  ssh_aes128_gcm = false
  ssh_chacha     = false
}

data "aci_rest_managed" "commPol" {
  dn = "uni/fabric/comm-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "commPol" {
  component = "commPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.commPol.content.name
    want        = module.main.name
  }
}
