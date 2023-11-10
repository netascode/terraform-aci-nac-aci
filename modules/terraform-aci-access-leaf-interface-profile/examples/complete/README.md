<!-- BEGIN_TF_DOCS -->
# Access Leaf Interface Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_leaf_interface_profile" {
  source  = "netascode/access-leaf-interface-profile/aci"
  version = ">= 0.1.0"

  name = "INT-PROF1"
}
```
<!-- END_TF_DOCS -->