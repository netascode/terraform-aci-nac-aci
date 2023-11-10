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

  ldap_providers = [{
    hostname_ip = "1.1.1.1"
    description = "My description"
  }]
}

data "aci_rest_managed" "aaaLdapProvider" {
  dn = "uni/userext/ldapext/ldapprovider-1.1.1.1"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLdapProvider" {
  component = "aaaLdapProvider"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaLdapProvider.content.name
    want        = "1.1.1.1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.aaaLdapProvider.content.descr
    want        = "My description"
  }
}
