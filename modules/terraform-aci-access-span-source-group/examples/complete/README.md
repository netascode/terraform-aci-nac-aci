<!-- BEGIN_TF_DOCS -->
# Access SPAN Source Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci-access-span-source-group" {
  source      = "netascode/access-span-source-group/aci"
  version     = "0.0.1"
  name        = "SPAN1"
  description = "My Test Span Group"
  admin_state = false
  sources = [
    {
      name                = "SRC1"
      description         = "Source1"
      direction           = "both"
      span_drop           = "no"
      tenant              = "TEN1"
      application_profile = "APP1"
      endpoint_group      = "EPG1"
      access_paths = [
        {
          node_id = 1001
          port    = 11
        },
        {
          node_id  = 101
          node2_id = 102
          fex_id   = 151
          fex2_id  = 152
          channel  = "ipg_vpc_test"
        },
        {
          node_id = 101
          fex_id  = 151
          channel = "ipg_regular-po_test"
        },
        {
          node_id = 101
          fex_id  = 151
          port    = 1
        }
      ]
    },
  ]
  filter_group = "FILTER1"
  destination = {
    name        = "DESTINATION1"
    description = "My Destination"
  }
}
```
<!-- END_TF_DOCS -->