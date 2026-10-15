<!-- BEGIN_TF_DOCS -->
# Data Plane Policing Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_data_plane_policing_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-data-plane-policing-policy"
  version = ">= 0.9.3"

  name                 = "dpp-pol1"
  admin_state          = true
  type                 = "1R2C"
  mode                 = "bit"
  sharing_mode         = "dedicated"
  peak_rate            = "10"
  peak_rate_unit       = "giga"
  rate                 = "9"
  rate_unit            = "giga"
  burst_excessive      = "9100"
  burst_excessive_unit = "mega"
  burst                = "0"
  burst_unit           = "unspecified"
  conform_action       = "transmit"
  conform_mark_cos     = "unspecified"
  conform_mark_dscp    = "unspecified"
  exceed_action        = "mark"
  exceed_mark_cos      = "3"
  exceed_mark_dscp     = "18"
  violate_action       = "mark"
  violate_mark_cos     = "2"
  violate_mark_dscp    = "38"
}
```
<!-- END_TF_DOCS -->