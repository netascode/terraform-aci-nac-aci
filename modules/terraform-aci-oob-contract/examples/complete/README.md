<!-- BEGIN_TF_DOCS -->
# OOB Contract Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_oob_contract" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-oob-contract"
  version = ">= 0.8.0"

  name        = "OOB1"
  alias       = "OOB1-ALIAS"
  description = "My Description"
  scope       = "global"
  subjects = [{
    name        = "SUB1"
    alias       = "SUB1-ALIAS"
    description = "Subject Description"
    filters = [{
      filter = "FILTER1"
    }]
  }]
}
```
<!-- END_TF_DOCS -->