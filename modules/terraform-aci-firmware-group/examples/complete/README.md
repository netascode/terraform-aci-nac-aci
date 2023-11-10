<!-- BEGIN_TF_DOCS -->
# Firmware Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_firmware_group" {
  source  = "netascode/firmware-group/aci"
  version = ">= 0.1.0"

  name     = "UG1"
  node_ids = [101, 103]
}
```
<!-- END_TF_DOCS -->