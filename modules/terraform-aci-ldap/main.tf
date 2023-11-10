resource "aci_rest_managed" "aaaLdapProvider" {
  for_each = { for prov in var.ldap_providers : prov.hostname_ip => prov }

  dn         = "uni/userext/ldapext/ldapprovider-${each.key}"
  class_name = "aaaLdapProvider"
  content = {
    name               = each.value.hostname_ip
    descr              = each.value.description
    SSLValidationLevel = each.value.ssl_validation_level
    basedn             = each.value.base_dn
    enableSSL          = each.value.enable_ssl ? "yes" : "no"
    filter             = each.value.filter
    attribute          = each.value.attribute
    monitorServer      = each.value.monitoring == true ? "enabled" : "disabled"
    monitoringUser     = each.value.monitoring == true ? each.value.monitoring_username : null
    monitoringPassword = each.value.monitoring == true ? each.value.monitoring_password : null
    key                = each.value.password
    port               = each.value.port
    retries            = each.value.retries
    rootdn             = each.value.bind_dn
    timeout            = each.value.timeout
  }

  lifecycle {
    ignore_changes = [content["key"], content["monitoringPassword"]]
  }
}

resource "aci_rest_managed" "aaaRsSecProvToEpg" {
  for_each = { for prov in var.ldap_providers : prov.hostname_ip => prov if prov.mgmt_epg_name != "" }

  dn         = "${aci_rest_managed.aaaLdapProvider[each.key].dn}/rsSecProvToEpg"
  class_name = "aaaRsSecProvToEpg"
  content = {
    tDn = each.value.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${each.value.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${each.value.mgmt_epg_name}"
  }
}

resource "aci_rest_managed" "aaaLdapGroupMapRule" {
  for_each = { for rule in var.group_map_rules : rule.name => rule }

  dn         = "uni/userext/ldapext/ldapgroupmaprule-${each.key}"
  class_name = "aaaLdapGroupMapRule"
  content = {
    name    = each.value.name
    descr   = each.value.description
    groupdn = each.value.group_dn
  }
}

locals {
  user_domains = flatten([
    for rule in var.group_map_rules : [
      for dom in rule.security_domains : {
        key  = format("%s/%s", rule.name, dom.name)
        rule = rule.name
        name = dom.name

      }
    ]
  ])
}

resource "aci_rest_managed" "aaaUserDomain" {
  for_each = { for dom in local.user_domains : dom.key => dom }

  dn         = "${aci_rest_managed.aaaLdapGroupMapRule[each.value.rule].dn}/userdomain-${each.value.name}"
  class_name = "aaaUserDomain"
  content = {
    name = each.value.name
  }
}

locals {
  user_roles = flatten([
    for rule in var.group_map_rules : [
      for dom in rule.security_domains : [
        for role in dom.roles : {
          key    = format("%s/%s/%s", rule.name, dom.name, role.name)
          domain = format("%s/%s", rule.name, dom.name)
          name   = role.name
          priv   = role.privilege_type
        }
      ]
    ]
  ])
}

resource "aci_rest_managed" "aaaUserRole" {
  for_each = { for role in local.user_roles : role.key => role }

  dn         = "${aci_rest_managed.aaaUserDomain[each.value.domain].dn}/role-${each.value.name}"
  class_name = "aaaUserRole"
  content = {
    name     = each.value.name
    privType = each.value.priv == "read" ? "readPriv" : (each.value.priv == "write" ? "writePriv" : null)
  }
}

resource "aci_rest_managed" "aaaLdapGroupMap" {
  for_each = { for group in var.group_maps : group.name => group }

  dn         = "uni/userext/ldapext/ldapgroupmap-${each.key}"
  class_name = "aaaLdapGroupMap"
  content = {
    name = each.value.name
  }
}

locals {
  map_rules = flatten([
    for group in var.group_maps : [
      for rule in group.rules : {
        key   = format("%s/%s", group.name, rule)
        group = group.name
        rule  = rule
      }
    ]
  ])
}

resource "aci_rest_managed" "aaaLdapGroupMapRuleRef" {
  for_each = { for rule in local.map_rules : rule.key => rule }

  dn         = "${aci_rest_managed.aaaLdapGroupMap[each.value.group].dn}/ldapgroupmapruleref-${each.value.rule}"
  class_name = "aaaLdapGroupMapRuleRef"
  content = {
    name = each.value.rule
  }
}
