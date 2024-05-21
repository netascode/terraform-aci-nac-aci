<!-- BEGIN_TF_DOCS -->
# PTP Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ptp_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-aaep"
  version = ">= 0.8.0"

  name              = "PTP1"
  announce_interval = -3
  announce_timeout  = 2
  delay_interval    = -4
  sync_interval     = -4
  forwardable       = false
  template          = "telecom"
  mismatch_handling = "configured"
  priority          = 201
}
```
<!-- END_TF_DOCS -->