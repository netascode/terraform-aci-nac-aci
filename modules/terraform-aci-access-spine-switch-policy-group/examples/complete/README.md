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
  source  = "netascode/access-spine-switch-policy-group/aci"
  version = ">= 0.1.0"

  name        = "SW-PG1"
  lldp_policy = "LLDP-ON"
}
```
<!-- END_TF_DOCS -->