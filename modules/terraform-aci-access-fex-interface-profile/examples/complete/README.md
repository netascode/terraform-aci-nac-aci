<!-- BEGIN_TF_DOCS -->
# Access FEX Interface Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_fex_interface_profile" {
  source  = "netascode/access-fex-interface-profile/aci"
  version = ">= 0.1.0"

  name = "FEX1"
}
```
<!-- END_TF_DOCS -->