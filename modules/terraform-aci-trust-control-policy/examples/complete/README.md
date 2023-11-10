<!-- BEGIN_TF_DOCS -->
# Trust Control Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_trust_control_policy" {
  source  = "netascode/trust-control-policy/aci"
  version = ">= 0.1.0"

  tenant         = "ABC"
  name           = "TCP1"
  description    = "My Description"
  dhcp_v4_server = true
  dhcp_v6_server = true
  ipv6_router    = true
  arp            = true
  nd             = true
  ra             = true
}
```
<!-- END_TF_DOCS -->