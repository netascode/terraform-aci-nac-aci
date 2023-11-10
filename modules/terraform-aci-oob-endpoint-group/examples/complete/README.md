<!-- BEGIN_TF_DOCS -->
# OOB Endpoint Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_oob_endpoint_group" {
  source  = "netascode/oob-endpoint-group/aci"
  version = ">= 0.1.0"

  name                   = "OOB1"
  oob_contract_providers = ["OOB-CON1"]
}
```
<!-- END_TF_DOCS -->