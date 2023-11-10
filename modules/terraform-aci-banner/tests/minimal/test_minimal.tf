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
}

data "aci_rest_managed" "aaaPreLoginBanner" {
  dn = "uni/userext/preloginbanner"

  depends_on = [module.main]
}

resource "test_assertions" "aaaPreLoginBanner" {
  component = "aaaPreLoginBanner"

  equal "guiMessage" {
    description = "guiMessage"
    got         = data.aci_rest_managed.aaaPreLoginBanner.content.guiMessage
    want        = ""
  }

  equal "guiTextMessage" {
    description = "guiTextMessage"
    got         = data.aci_rest_managed.aaaPreLoginBanner.content.guiTextMessage
    want        = ""
  }

  equal "message" {
    description = "message"
    got         = data.aci_rest_managed.aaaPreLoginBanner.content.message
    want        = ""
  }

  equal "switchMessage" {
    description = "switchMessage"
    got         = data.aci_rest_managed.aaaPreLoginBanner.content.switchMessage
    want        = ""
  }
}
