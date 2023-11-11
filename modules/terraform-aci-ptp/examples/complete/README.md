<!-- BEGIN_TF_DOCS -->
# PTP Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ptp" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ptp"
  version = ">= 0.8.0"

  admin_state       = true
  global_domain     = 0
  profile           = "aes67"
  announce_interval = 1
  announce_timeout  = 3
  sync_interval     = -3
  delay_interval    = -2
}
```
<!-- END_TF_DOCS -->