resource "aci_rest_managed" "aaaAuthRealm" {
  dn         = "uni/userext/authrealm"
  class_name = "aaaAuthRealm"
  content = {
    defRolePolicy = var.remote_user_login_policy
  }
}

resource "aci_rest_managed" "aaaDefaultAuth" {
  dn         = "${aci_rest_managed.aaaAuthRealm.dn}/defaultauth"
  class_name = "aaaDefaultAuth"
  content = {
    fallbackCheck = var.default_fallback_check ? "true" : "false"
    realm         = var.default_realm
    providerGroup = var.default_realm == "tacacs" || var.default_realm == "radius" ? var.default_login_domain : ""
  }
}

resource "aci_rest_managed" "aaaConsoleAuth" {
  dn         = "${aci_rest_managed.aaaAuthRealm.dn}/consoleauth"
  class_name = "aaaConsoleAuth"
  content = {
    realm         = var.console_realm
    providerGroup = var.console_realm == "tacacs" || var.console_realm == "radius" ? var.console_login_domain : ""
  }
}

resource "aci_rest_managed" "aaaDomain" {
  for_each   = { for sd in var.security_domains : sd.name => sd }
  dn         = "uni/userext/domain-${each.value.name}"
  class_name = "aaaDomain"
  content = {
    name                 = each.value.name
    descr                = each.value.description
    restrictedRbacDomain = each.value.restricted_rbac_domain == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "aaaUserEp" {
  dn         = "uni/userext"
  class_name = "aaaUserEp"
  content = {
    pwdStrengthCheck = var.password_strength_check == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "pkiWebTokenData" {
  dn         = "uni/userext/pkiext/webtokendata"
  class_name = "pkiWebTokenData"
  content = {
    webtokenTimeoutSeconds = var.web_token_timeout
    maximumValidityPeriod  = var.web_token_max_validity
    uiIdleTimeoutSeconds   = var.web_session_idle_timeout
  }
}
