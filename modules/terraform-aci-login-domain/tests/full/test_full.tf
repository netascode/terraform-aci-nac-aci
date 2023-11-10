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

  name           = "LDAP1"
  description    = "My Description"
  realm          = "ldap"
  auth_choice    = "LdapGroupMap"
  ldap_group_map = "GM1"
  ldap_providers = [{
    hostname_ip = "10.1.1.10"
    priority    = 10
  }]
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

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.aaaLoginDomain.content.descr
    want        = "My Description"
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
    want        = "ldap"
  }

  equal "providerGroup" {
    description = "providerGroup"
    got         = data.aci_rest_managed.aaaDomainAuth.content.providerGroup
    want        = module.main.name
  }
}

data "aci_rest_managed" "aaaLdapProviderGroup" {
  dn = "uni/userext/ldapext/ldapprovidergroup-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLdapProviderGroup" {
  component = "aaaLdapProviderGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaLdapProviderGroup.content.name
    want        = module.main.name
  }

  equal "authChoice" {
    description = "namauthChoicee"
    got         = data.aci_rest_managed.aaaLdapProviderGroup.content.authChoice
    want        = "LdapGroupMap"
  }

  equal "ldapGroupMapRef" {
    description = "ldapGroupMapRef"
    got         = data.aci_rest_managed.aaaLdapProviderGroup.content.ldapGroupMapRef
    want        = "GM1"
  }
}

data "aci_rest_managed" "aaaProviderRef" {
  dn = "${data.aci_rest_managed.aaaLdapProviderGroup.id}/providerref-10.1.1.10"

  depends_on = [module.main]
}

resource "test_assertions" "aaaProviderRef" {
  component = "aaaProviderRef"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaProviderRef.content.name
    want        = "10.1.1.10"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.aaaProviderRef.content.order
    want        = "10"
  }
}
