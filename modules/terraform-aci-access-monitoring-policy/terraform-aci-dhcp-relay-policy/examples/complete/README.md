<!-- BEGIN_TF_DOCS -->
# Monitoring Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_infra_monitoring_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-monitoring-policy"
  version = ">= 0.8.0"
  name        = "INFRA-MONITORING-POL"
  description = "My Description"
}
```
<!-- END_TF_DOCS -->