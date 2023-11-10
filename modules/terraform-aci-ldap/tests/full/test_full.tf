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
    hostname_ip          = "1.1.1.1"
    description          = "My Description"
    port                 = 149
    bind_dn              = "CN=testuser,OU=Employees,OU=Cisco users,DC=cisco,DC=com"
    base_dn              = "OU=Employees,OU=Cisco users,DC=cisco,DC=com"
    password             = "ABCDEFGH"
    timeout              = 10
    retries              = 3
    enable_ssl           = true
    filter               = "cn=$userid"
    attribute            = "memberOf"
    ssl_validation_level = "permissive"
    mgmt_epg_type        = "oob"
    mgmt_epg_name        = "OOB1"
    monitoring           = true
    monitoring_username  = "USER1"
    monitoring_password  = "PASSWORD1"
  }]
  group_map_rules = [{
    name        = "test-users-rules"
    description = "description"
    group_dn    = "CN=test-users,OU=Cisco groups,DC=cisco,DC=com"
    security_domains = [{
      name = "all"
      roles = [{
        name           = "admin"
        privilege_type = "write"
      }]
    }]
  }]
  group_maps = [{
    name  = "test-users-map"
    rules = ["test-users-rules"]
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
    want        = "My Description"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.aaaLdapProvider.content.port
    want        = "149"
  }

  equal "rootdn" {
    description = "rootdn"
    got         = data.aci_rest_managed.aaaLdapProvider.content.rootdn
    want        = "CN=testuser,OU=Employees,OU=Cisco users,DC=cisco,DC=com"
  }

  equal "basedn" {
    description = "basedn"
    got         = data.aci_rest_managed.aaaLdapProvider.content.basedn
    want        = "OU=Employees,OU=Cisco users,DC=cisco,DC=com"
  }

  equal "enableSSL" {
    description = "enableSSL"
    got         = data.aci_rest_managed.aaaLdapProvider.content.enableSSL
    want        = "yes"
  }

  equal "filter" {
    description = "filter"
    got         = data.aci_rest_managed.aaaLdapProvider.content.filter
    want        = "cn=$userid"
  }

  equal "monitoringUser" {
    description = "monitoringUser"
    got         = data.aci_rest_managed.aaaLdapProvider.content.monitoringUser
    want        = "USER1"
  }

  equal "attribute" {
    description = "attribute"
    got         = data.aci_rest_managed.aaaLdapProvider.content.attribute
    want        = "memberOf"
  }

  equal "ssl_validation_level" {
    description = "ssl_validation_level"
    got         = data.aci_rest_managed.aaaLdapProvider.content.SSLValidationLevel
    want        = "permissive"
  }

  equal "timeout" {
    description = "timeout"
    got         = data.aci_rest_managed.aaaLdapProvider.content.timeout
    want        = "10"
  }

  equal "retries" {
    description = "retries"
    got         = data.aci_rest_managed.aaaLdapProvider.content.retries
    want        = "3"
  }
}


data "aci_rest_managed" "aaaRsSecProvToEpg" {
  dn = "uni/userext/ldapext/ldapprovider-1.1.1.1/rsSecProvToEpg"

  depends_on = [module.main]
}

resource "test_assertions" "aaaRsSecProvToEpg" {
  component = "aaaRsSecProvToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.aaaRsSecProvToEpg.content.tDn
    want        = "uni/tn-mgmt/mgmtp-default/oob-OOB1"
  }
}


data "aci_rest_managed" "aaaLdapGroupMapRule" {
  dn = "uni/userext/ldapext/ldapgroupmaprule-test-users-rules"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLdapGroupMapRule" {
  component = "aaaLdapGroupMapRule"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaLdapGroupMapRule.content.name
    want        = "test-users-rules"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.aaaLdapGroupMapRule.content.descr
    want        = "description"
  }
}


data "aci_rest_managed" "aaaUserDomain" {
  dn = "uni/userext/ldapext/ldapgroupmaprule-test-users-rules/userdomain-all"

  depends_on = [module.main]
}

resource "test_assertions" "aaaUserDomain" {
  component = "aaaUserDomain"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaUserDomain.content.name
    want        = "all"
  }
}


data "aci_rest_managed" "aaaUserRole" {
  dn = "uni/userext/ldapext/ldapgroupmaprule-test-users-rules/userdomain-all/role-admin"

  depends_on = [module.main]
}

resource "test_assertions" "aaaUserRole" {
  component = "aaaUserRole"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaUserRole.content.name
    want        = "admin"
  }

  equal "privilege_type" {
    description = "privilege_type"
    got         = data.aci_rest_managed.aaaUserRole.content.privType
    want        = "writePriv"
  }
}

data "aci_rest_managed" "aaaLdapGroupMap" {
  dn = "uni/userext/ldapext/ldapgroupmap-test-users-map"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLdapGroupMap" {
  component = "aaaLdapGroupMap"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaLdapGroupMap.content.name
    want        = "test-users-map"
  }
}

data "aci_rest_managed" "aaaLdapGroupMapRuleRef" {
  dn = "uni/userext/ldapext/ldapgroupmap-test-users-map/ldapgroupmapruleref-test-users-rules"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLdapGroupMapRuleRef" {
  component = "aaaLdapGroupMapRuleRef"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaLdapGroupMapRuleRef.content.name
    want        = "test-users-rules"
  }
}
