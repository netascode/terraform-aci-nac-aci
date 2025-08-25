<!-- BEGIN_TF_DOCS -->
# Banner Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_banner" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-banner"
  version = ">= 0.8.0"

  apic_gui_banner_url      = "http://1.1.1.1"
  apic_gui_alias           = "PROD"
  apic_cli_banner          = "My CLI Banner"
  switch_cli_banner        = "My Switch Banner"
  apic_app_banner          = "My Application Banner"
  apic_app_banner_severity = "warning"
}
```
<!-- END_TF_DOCS -->