<!-- BEGIN_TF_DOCS -->
# EIGRP Interface Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_eigrp_interface_policy" {
  source  = "netascode/eigrp-interface-policy/aci"
  version = ">= 0.1.0"

  tenant            = "TF"
  name              = "EIGRP1"
  description       = "My Description"
  hello_interval    = 10
  hold_interval     = 30
  bandwidth         = 10
  delay             = 20
  delay_unit        = "pico"
  bfd               = true
  self_nexthop      = true
  passive_interface = true
  split_horizon     = true
}
```
<!-- END_TF_DOCS -->