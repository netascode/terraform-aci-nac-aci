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
    providerGroup = var.default_realm == "tacacs" || var.default_realm == "radius" || var.default_realm == "ldap" ? var.default_login_domain : ""
  }
}

resource "aci_rest_managed" "aaaConsoleAuth" {
  dn         = "${aci_rest_managed.aaaAuthRealm.dn}/consoleauth"
  class_name = "aaaConsoleAuth"
  content = {
    realm         = var.console_realm
    providerGroup = var.console_realm == "tacacs" || var.console_realm == "radius" || var.default_realm == "ldap" ? var.console_login_domain : ""
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

resource "aci_rest_managed" "aaaPwdStrengthProfile" {
  count = var.password_strength_check ? 1 : 0

  dn         = "uni/userext/pwdstrengthprofile"
  class_name = "aaaPwdStrengthProfile"
  content = {
    pwdMinLength        = var.min_password_length
    pwdMaxLength        = var.max_password_length
    pwdStrengthTestType = var.password_strength_test_type
    pwdClassFlags       = var.password_strength_test_type == "custom" ? join(",", sort(var.password_class_flags)) : join(",", ["digits", "lowercase", "uppercase"])
  }

  depends_on = [
    aci_rest_managed.aaaUserEp
  ]
}

resource "aci_rest_managed" "aaaPwdProfile" {
  dn         = "uni/userext/pwdprofile"
  class_name = "aaaPwdProfile"
  content = {
    changeDuringInterval = var.password_change_during_interval ? "enable" : "disable"
    changeInterval       = var.password_change_interval
    changeCount          = var.password_change_count
    noChangeInterval     = var.password_no_change_interval
    historyCount         = var.password_history_count

  }
}

resource "aci_rest_managed" "pkiWebTokenData" {
  dn         = "uni/userext/pkiext/webtokendata"
  class_name = "pkiWebTokenData"
  content = {
    webtokenTimeoutSeconds = var.web_token_timeout
    maximumValidityPeriod  = var.web_token_max_validity
    uiIdleTimeoutSeconds   = var.web_session_idle_timeout
    sessionRecordFlags     = var.include_refresh_session_records ? "login,logout,refresh" : "login,logout"
  }
}

resource "aci_rest_managed" "aaaBlockLoginProfile" {
  dn         = "uni/userext/blockloginp"
  class_name = "aaaBlockLoginProfile"
  content = {
    enableLoginBlock        = var.enable_login_block ? "enable" : "disable"
    blockDuration           = var.login_block_duration
    maxFailedAttempts       = var.login_max_failed_attempts
    maxFailedAttemptsWindow = var.login_max_failed_attempts_window
  }
}
