module "aci_aaa" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-aaa"
  version = ">= 0.8.0"

  remote_user_login_policy = "assign-default-role"
  default_fallback_check   = true
  default_realm            = "tacacs"
  default_login_domain     = "ISE"
  console_realm            = "tacacs"
  console_login_domain     = "ISE"
  password_strength_check  = true
  web_token_timeout        = 600
  web_token_max_validity   = 24
  web_session_idle_timeout = 1200
}
