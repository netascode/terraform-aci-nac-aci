<!-- BEGIN_TF_DOCS -->
# Login Domain Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_login_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-login-domain"
  version = ">= 0.8.0"

  name        = "TACACS1"
  description = "My Description"
  realm       = "tacacs"
  tacacs_providers = [{
    hostname_ip = "10.1.1.10"
    priority    = 10
  }]
}
```
<!-- END_TF_DOCS -->