<!-- BEGIN_TF_DOCS -->
# External Connectivity Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_external_connectivity_policy" {
  source  = "netascode/external-connectivity-policy/aci"
  version = ">= 0.2.0"

  name         = "EXT-POL1"
  route_target = "extended:as2-nn4:5:17"
  fabric_id    = 2
  site_id      = 2
  bgp_password = "SECRETPW"
  routing_profiles = [{
    name        = "PROF1"
    description = "My Description"
    subnets     = ["10.0.0.0/24"]
  }]
  data_plane_teps = [{
    pod_id = 2
    ip     = "11.1.1.11"
  }]
  unicast_teps = [{
    pod_id = 2
    ip     = "1.2.3.4"
  }]
}
```
<!-- END_TF_DOCS -->