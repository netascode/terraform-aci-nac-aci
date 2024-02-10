<!-- BEGIN_TF_DOCS -->
# AAA Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_aaa" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-aaa"
  version = ">= 0.8.0"

  remote_user_login_policy         = "assign-default-role"
  default_fallback_check           = true
  default_realm                    = "tacacs"
  default_login_domain             = "ISE"
  console_realm                    = "tacacs"
  console_login_domain             = "ISE"
  password_strength_check          = true
  min_password_length              = 8
  max_password_length              = 64
  password_strength_test_type      = "custom"
  password_class_flags             = ["digits", "lowercase", "specialchars", "uppercase"]
  password_change_during_interval  = true
  password_change_interval         = 72
  password_change_count            = 3
  password_history_count           = 6
  password_no_change_interval      = 24
  web_token_timeout                = 600
  web_token_max_validity           = 24
  web_session_idle_timeout         = 1200
  include_refresh_session_records  = true
  enable_login_block               = true
  login_block_duration             = 60
  login_max_failed_attempts        = 5
  login_max_failed_attempts_window = 5
}
```
<!-- END_TF_DOCS -->