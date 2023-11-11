<!-- BEGIN_TF_DOCS -->
# IP SLA Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ip_sla_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ip-sla-policy"
  version = ">= 0.8.0"

  name        = "ABC"
  description = "My Description"
  tenant      = "TEN1"
  multiplier  = 10
  frequency   = 120
  sla_type    = "tcp"
  port        = 65001
}
```
<!-- END_TF_DOCS -->