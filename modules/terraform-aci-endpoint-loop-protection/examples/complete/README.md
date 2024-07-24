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
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-loop-protection"
  version = ">= 0.8.0"

  admin_state          = true
  bd_learn_disable     = true
  port_disable         = false
  detection_interval   = 90
  detection_multiplier = 10
}
```
<!-- END_TF_DOCS -->