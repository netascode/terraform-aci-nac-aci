<!-- BEGIN_TF_DOCS -->
# OSPF Interface Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ospf_interface_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ospf-interface-policy"
  version = ">= 0.8.0"

  tenant                  = "ABC"
  name                    = "OSPF1"
  description             = "My Description"
  cost                    = "10"
  dead_interval           = 50
  hello_interval          = 15
  network_type            = "p2p"
  priority                = 10
  lsa_retransmit_interval = 10
  lsa_transmit_delay      = 3
  passive_interface       = true
  mtu_ignore              = true
  advertise_subnet        = true
  bfd                     = true
}
```
<!-- END_TF_DOCS -->