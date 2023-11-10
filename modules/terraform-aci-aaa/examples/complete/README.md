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
  source  = "netascode/aaa/aci"
  version = ">= 0.1.0"

  remote_user_login_policy = "assign-default-role"
  default_fallback_check   = true
  default_realm            = "tacacs"
  default_login_domain     = "ISE"
  console_realm            = "tacacs"
  console_login_domain     = "ISE"
}
```
<!-- END_TF_DOCS -->