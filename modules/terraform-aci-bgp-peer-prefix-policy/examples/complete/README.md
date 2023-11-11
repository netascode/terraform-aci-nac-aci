<!-- BEGIN_TF_DOCS -->
# BGP Peer Prefix Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_bgp_peer_prefix_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-bgp-peer-prefix-policy"
  version = ">= 0.8.0"

  name         = "ABC"
  tenant       = "TEN1"
  description  = "My BGP Peer Prefix Policy"
  action       = "restart"
  max_prefixes = 10000
  restart_time = 5000
  threshold    = 90
}
```
<!-- END_TF_DOCS -->