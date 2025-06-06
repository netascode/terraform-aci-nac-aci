<!-- BEGIN_TF_DOCS -->
# Fabric Leaf Interface Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_leaf_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-leaf-interface-policy-group"
  version = ">= 0.8.0"

  name              = "LEAFS"
  link_level_policy = "default"
  monitoring_policy = "default"
}
```
<!-- END_TF_DOCS -->