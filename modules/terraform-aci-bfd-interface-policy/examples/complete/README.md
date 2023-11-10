<!-- BEGIN_TF_DOCS -->
# BFD Interface Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_bfd_interface_policy" {
  source  = "netascode/bfd-interface-policy/aci"
  version = ">= 0.1.0"

  tenant                    = "ABC"
  name                      = "BFD1"
  description               = "My Description"
  subinterface_optimization = true
  detection_multiplier      = 10
  echo_admin_state          = true
  echo_rx_interval          = 100
  min_rx_interval           = 100
  min_tx_interval           = 100
}
```
<!-- END_TF_DOCS -->