<!-- BEGIN_TF_DOCS -->
# Fabric Leaf Switch Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_leaf_switch_policy_group" {
  source  = "netascode/fabric-leaf-switch-policy-group/aci"
  version = ">= 0.1.0"

  name                = "LEAFS"
  psu_policy          = "PSU1"
  node_control_policy = "NC1"
}
```
<!-- END_TF_DOCS -->