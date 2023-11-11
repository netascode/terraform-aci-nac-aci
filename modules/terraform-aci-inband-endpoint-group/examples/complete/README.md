<!-- BEGIN_TF_DOCS -->
# Inband Endpoint Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_inband_endpoint_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-inband-endpoint-group"
  version = ">= 0.8.0"

  name                        = "INB1"
  vlan                        = 10
  bridge_domain               = "INB1"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
}
```
<!-- END_TF_DOCS -->