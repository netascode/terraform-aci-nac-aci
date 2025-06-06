<!-- BEGIN_TF_DOCS -->
# Access SPAN Filter Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_span_filter_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-access-span-filter-group"
  version = ">= 0.8.0"

  name        = "ABC"
  description = "My Filter Group"
  entries = [
    {
      name                  = "HTTP"
      description           = "My Entry"
      source_ip             = "1.1.1.1"
      destination_ip        = "2.2.2.2"
      source_from_port      = 2001
      source_to_port        = 2002
      destination_to_port   = "http"
      destination_from_port = "http"
    },
    {
      source_ip      = "3.3.3.3"
      destination_ip = "4.4.4.4"
    }
  ]
}
```
<!-- END_TF_DOCS -->