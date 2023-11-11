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
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-leaf-interface-profile"
  version = ">= 0.8.0"

  name = "INT-PROF1"
}
```
<!-- END_TF_DOCS -->