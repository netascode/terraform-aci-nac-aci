<!-- BEGIN_TF_DOCS -->
# Access Spine Switch Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_spine_switch_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-spine-switch-policy-group"
  version = ">= 0.8.0"

  name        = "SW-PG1"
  lldp_policy = "LLDP-ON"
}
```
<!-- END_TF_DOCS -->