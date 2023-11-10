resource "aci_rest_managed" "aaaLoginDomain" {
  dn         = "uni/userext/logindomain-${var.name}"
  class_name = "aaaLoginDomain"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "aaaDomainAuth" {
  dn         = "${aci_rest_managed.aaaLoginDomain.dn}/domainauth"
  class_name = "aaaDomainAuth"
  content = {
    realm         = var.realm
    providerGroup = contains(["tacacs", "ldap"], var.realm) ? var.name : null
  }
}

resource "aci_rest_managed" "aaaTacacsPlusProviderGroup" {
  count      = var.realm == "tacacs" ? 1 : 0
  dn         = "uni/userext/tacacsext/tacacsplusprovidergroup-${var.name}"
  class_name = "aaaTacacsPlusProviderGroup"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "aaaProviderRef" {
  for_each   = { for prov in var.tacacs_providers : prov.hostname_ip => prov if var.realm == "tacacs" }
  dn         = "${aci_rest_managed.aaaTacacsPlusProviderGroup[0].dn}/providerref-${each.value.hostname_ip}"
  class_name = "aaaProviderRef"
  content = {
    name  = each.value.hostname_ip
    order = each.value.priority
  }
}

resource "aci_rest_managed" "aaaLdapProviderGroup" {
  count      = var.realm == "ldap" ? 1 : 0
  dn         = "uni/userext/ldapext/ldapprovidergroup-${var.name}"
  class_name = "aaaLdapProviderGroup"
  content = {
    name            = var.name
    authChoice      = var.auth_choice
    ldapGroupMapRef = var.ldap_group_map != "" ? var.ldap_group_map : null
  }
}

resource "aci_rest_managed" "aaaProviderRef_ldap" {
  for_each   = { for prov in var.ldap_providers : prov.hostname_ip => prov if var.realm == "ldap" }
  dn         = "${aci_rest_managed.aaaLdapProviderGroup[0].dn}/providerref-${each.value.hostname_ip}"
  class_name = "aaaProviderRef"
  content = {
    name  = each.value.hostname_ip
    order = each.value.priority
  }
}
