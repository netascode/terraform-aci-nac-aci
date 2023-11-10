<!-- BEGIN_TF_DOCS -->
# Imported Contract Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_imported_contract" {
  source  = "netascode/imported-contract/aci"
  version = ">= 0.1.0"

  tenant          = "ABC"
  name            = "CON1"
  source_tenant   = "DEF"
  source_contract = "CON1"
}
```
<!-- END_TF_DOCS -->