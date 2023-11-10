<!-- BEGIN_TF_DOCS -->
# Infra DSCP Translation Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_infra_dscp_translation_policy" {
  source  = "netascode/infra-dscp-translation-policy/aci"
  version = ">= 0.1.0"

  admin_state   = true
  control_plane = "CS1"
  level_1       = "CS2"
  level_2       = "CS3"
  level_3       = "CS4"
  level_4       = "CS5"
  level_5       = "CS6"
  level_6       = "CS7"
  policy_plane  = "AF11"
  span          = "AF12"
  traceroute    = "AF13"
}
```
<!-- END_TF_DOCS -->