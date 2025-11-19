<!-- BEGIN_TF_DOCS -->
# Border Gateway Policy Set Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_storm_control_policy" {
  source  = "netascode/nac-aci/aci/modules/terraform-aci-border-gateway-policy-set"
  version = ">= 0.8.0"

  name  = "BGW1"
  site_id = 100
  external_data_plane_ips = [
    {
      pod_id = 1
      ip     = "192.168.1.10"
    },
    {
      pod_id = 2
      ip     = "192.168.2.10"
    }
  ]
}
```
<!-- END_TF_DOCS -->