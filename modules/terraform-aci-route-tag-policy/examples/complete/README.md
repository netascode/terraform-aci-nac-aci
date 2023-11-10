<!-- BEGIN_TF_DOCS -->
# Route Tag Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_route_tag_policy" {
  source  = "netascode/route-tag-policy/aci"
  version = ">= 0.1.0"

  tenant      = "TEN1"
  name        = "TAG1"
  description = "My Tag"
  tag         = 12345
}
```
<!-- END_TF_DOCS -->