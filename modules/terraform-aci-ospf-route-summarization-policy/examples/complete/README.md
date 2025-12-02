<!-- BEGIN_TF_DOCS -->
# OSPF Route Summarization Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ospf_route_summarization_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ospf-route-summarization-policy"
  version = "> 1.1.0"

  tenant             = "ABC"
  name               = "OSPF_SUM1"
  description        = "My OSPF Route Summarization Policy"
  cost               = "100"
  inter_area_enabled = true
  tag                = 12345
  name_alias         = "OSPF_SUM_ALIAS"
}
```
<!-- END_TF_DOCS -->