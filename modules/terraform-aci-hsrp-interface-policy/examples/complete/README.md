<!-- BEGIN_TF_DOCS -->
# HSRP Interface Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_hsrp_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-hsrp-interface-policy"
  version = ">= 0.8.0"

  tenant       = "ABC"
  name         = "HSRP_IF1"
  description  = "My Description"
  bfd_enable   = true
  use_bia      = false
  delay        = 5
  reload_delay = 10
}
```
<!-- END_TF_DOCS -->