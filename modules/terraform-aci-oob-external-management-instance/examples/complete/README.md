<!-- BEGIN_TF_DOCS -->
# OOB External Management Instance Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_oob_external_management_instance" {
  source  = "netascode/oob-external-management-instance/aci"
  version = ">= 0.1.0"

  name                   = "INST1"
  subnets                = ["0.0.0.0/0"]
  oob_contract_consumers = ["CON1"]
}
```
<!-- END_TF_DOCS -->