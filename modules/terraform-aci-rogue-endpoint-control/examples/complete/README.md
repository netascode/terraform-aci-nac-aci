<!-- BEGIN_TF_DOCS -->
# Rogue Endpoint Control Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_rogue_endpoint_control" {
  source  = "netascode/rogue-endpoint-control/aci"
  version = ">= 0.1.0"

  admin_state          = true
  hold_interval        = 2000
  detection_interval   = 120
  detection_multiplier = 10
}
```
<!-- END_TF_DOCS -->