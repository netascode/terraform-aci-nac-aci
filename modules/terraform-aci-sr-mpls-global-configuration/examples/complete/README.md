<!-- BEGIN_TF_DOCS -->
# Terraform ACI SR MPLS Global Configuration Module

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_sr_mpls_global_configuration" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-sr-mpls-global-configuration"
  version = ">= 0.0.1"

  sr_global_block_minimum = 16000
  sr_global_block_maximum = 275999
}
```
<!-- END_TF_DOCS -->