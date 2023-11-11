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
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-fex-interface-profile"
  version = ">= 0.8.0"

  name = "FEX1"
}
```
<!-- END_TF_DOCS -->