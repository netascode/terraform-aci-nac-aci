terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.6.0"
    }
  }
}

module "main" {
  source = "../.."

  config_passphrase = "Cisco123!Cisco123!"
}

data "aci_rest_managed" "pkiExportEncryptionKey" {
  dn = "uni/exportcryptkey"

  depends_on = [module.main]
}

resource "test_assertions" "pkiExportEncryptionKey" {
  component = "pkiExportEncryptionKey"

  equal "strongEncryptionEnabled" {
    description = "strongEncryptionEnabled"
    got         = data.aci_rest_managed.pkiExportEncryptionKey.content.strongEncryptionEnabled
    want        = "yes"
  }
}
