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
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-switch-policy-group"
  version = ">= 0.8.0"

  name                = "LEAFS"
  psu_policy          = "PSU1"
  node_control_policy = "NC1"
}
```
<!-- END_TF_DOCS -->