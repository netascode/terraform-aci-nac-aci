<!-- BEGIN_TF_DOCS -->
# Switch Configuration Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_switch_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-switch-configuration"
  version = ">= 0.8.0"

  node_id             = 101
  role                = "leaf"
  access_policy_group = "LFACC1"
  fabric_policy_group = "LFFAB1"
}
```
<!-- END_TF_DOCS -->