<!-- BEGIN_TF_DOCS -->
# Access Leaf Switch Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_leaf_switch_policy_group" {
  source  = "netascode/access-leaf-switch-policy-group/aci"
  version = ">= 0.8.0"

  name                    = "SW-PG1"
  forwarding_scale_policy = "HIGH-DUAL-STACK"
}
```
<!-- END_TF_DOCS -->