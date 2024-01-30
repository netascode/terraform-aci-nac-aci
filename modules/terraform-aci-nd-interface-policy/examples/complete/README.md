<!-- BEGIN_TF_DOCS -->
# ND Interface Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_nd_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-nd-interface-policy"
  version = ">= 0.8.1"

  tenant                   = "ABC"
  name                     = "ND-INTF-POL1"
  description              = "My Description"
  controller_state         = ["other-cfg"]
  hop_limit                = 32
  ns_tx_interval           = 1000
  mtu                      = 9000
  retransmit_retry_count   = 3
  nud_retransmit_base      = 1
  nud_retransmit_interval  = 2000
  nud_retransmit_count     = 3
  route_advertise_interval = 600
  router_lifetime          = 3600
  reachable_time           = 0
  retransmit_timer         = 0
}
```
<!-- END_TF_DOCS -->