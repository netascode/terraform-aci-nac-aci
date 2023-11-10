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

module "main" {
  source = "../.."

  name  = "LOCAL1"
  realm = "local"
}

data "aci_rest_managed" "aaaLoginDomain" {
  dn = "uni/userext/logindomain-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLoginDomain" {
  component = "aaaLoginDomain"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaLoginDomain.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "aaaDomainAuth" {
  dn = "${data.aci_rest_managed.aaaLoginDomain.id}/domainauth"

  depends_on = [module.main]
}

resource "test_assertions" "aaaDomainAuth" {
  component = "aaaDomainAuth"

  equal "realm" {
    description = "realm"
    got         = data.aci_rest_managed.aaaDomainAuth.content.realm
    want        = "local"
  }
}
