<!-- BEGIN_TF_DOCS -->
# Config Export Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_config_export" {
  source  = "netascode/config-export/aci"
  version = ">= 0.1.0"

  name            = "EXP1"
  description     = "My Description"
  format          = "xml"
  snapshot        = true
  remote_location = "REMOTE1"
  scheduler       = "SCHEDULER1"
}
```
<!-- END_TF_DOCS -->