<!-- BEGIN_TF_DOCS -->
# Filter Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_filter" {
  source  = "netascode/filter/aci"
  version = ">= 0.2.0"

  tenant      = "ABC"
  name        = "FILTER1"
  alias       = "FILTER1-ALIAS"
  description = "My Description"
  entries = [{
    name                  = "ENTRY1"
    alias                 = "ENTRY1-ALIAS"
    description           = "Entry Description"
    ethertype             = "ip"
    protocol              = "tcp"
    source_from_port      = "123"
    source_to_port        = "124"
    destination_from_port = "234"
    destination_to_port   = "235"
    stateful              = true
  }]
}
```
<!-- END_TF_DOCS -->