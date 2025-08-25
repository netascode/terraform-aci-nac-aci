<!-- BEGIN_TF_DOCS -->
# Endpoint Retention Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_end_point_retention_policy" {
  source                         = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-retention-policy"
  version                        = ">= 0.9.4"
  name                           = "ERP1"
  descr                          = "Terraform"
  hold_interval                  = 6
  bounce_entry_aging_interval    = 630
  local_endpoint_aging_interval  = 900
  remote_endpoint_aging_interval = 300
  move_frequency                 = 256
}
```
<!-- END_TF_DOCS -->