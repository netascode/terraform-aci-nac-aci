<!-- BEGIN_TF_DOCS -->
# Service EPG Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_service_epg_policy" {
  source  = "netascode/service-epg-policy/aci"
  version = ">= 0.1.0"

  tenant          = "ABC"
  name            = "SERVICE_EPG_POLICY_1"
  description     = "My Description"
  preferred_group = true
}
```
<!-- END_TF_DOCS -->