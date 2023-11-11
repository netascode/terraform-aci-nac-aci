<!-- BEGIN_TF_DOCS -->
# Multicast Route Map Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_multicast_route_map" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-multicast-route-map"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "MRM1"
  description = "My Description"
  entries = [
    {
      order     = 1
      action    = "deny"
      source_ip = "1.2.3.4/32"
      group_ip  = "224.0.0.0/8"
      rp_ip     = "3.4.5.6"
    },
    {
      order = 2
    }
  ]
}
```
<!-- END_TF_DOCS -->