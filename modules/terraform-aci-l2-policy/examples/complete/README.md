<!-- BEGIN_TF_DOCS -->
# L2 Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_l2_policy" {
  source  = "netascode/l2-policy/aci"
  version = ">= 0.1.0"

  name             = "L2POL1"
  vlan_scope       = "portlocal"
  qinq             = "edgePort"
  reflective_relay = true
}
```
<!-- END_TF_DOCS -->