<!-- BEGIN_TF_DOCS -->
# Imported L4L7 Device Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_imported_l4l7_device" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-imported-l4l7-device"
  version = ">= 0.8.1"

  tenant        = "ABC"
  source_tenant = "DEF"
  source_device = "DEV1"
  description   = "My imported device"
}
```
<!-- END_TF_DOCS -->