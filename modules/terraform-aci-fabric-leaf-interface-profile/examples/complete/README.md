<!-- BEGIN_TF_DOCS -->
# Fabric Leaf Interface Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_leaf_interface_profile" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-abric-leaf-interface-profile"
  version = ">= 0.8.0"

  name = "LEAF101"
}
```
<!-- END_TF_DOCS -->