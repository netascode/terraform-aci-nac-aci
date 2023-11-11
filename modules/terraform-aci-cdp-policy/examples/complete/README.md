<!-- BEGIN_TF_DOCS -->
# CDP Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_cdp_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-cdp-policy"
  version = ">= 0.8.0"

  name        = "CDP1"
  admin_state = true
}
```
<!-- END_TF_DOCS -->