<!-- BEGIN_TF_DOCS -->
# Endpoint Loop Protection Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_endpoint_loop_protection" {
  source  = "netascode/endpoint-loop-protection/aci"
  version = ">= 0.1.0"

  action               = "bd-learn-disable"
  admin_state          = true
  detection_interval   = 90
  detection_multiplier = 10
}
```
<!-- END_TF_DOCS -->