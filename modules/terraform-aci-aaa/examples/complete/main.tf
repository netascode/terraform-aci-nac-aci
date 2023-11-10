module "aci_aaa" {
  source  = "netascode/aaa/aci"
  version = ">= 0.1.0"

  remote_user_login_policy = "assign-default-role"
  default_fallback_check   = true
  default_realm            = "tacacs"
  default_login_domain     = "ISE"
  console_realm            = "tacacs"
  console_login_domain     = "ISE"
}
