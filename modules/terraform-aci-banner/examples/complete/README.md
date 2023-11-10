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
  source  = "netascode/banner/aci"
  version = ">= 0.1.0"

  apic_gui_banner_url = "http://1.1.1.1"
  apic_gui_alias      = "PROD"
  apic_cli_banner     = "My CLI Banner"
  switch_cli_banner   = "My Switch Banner"
}
```
<!-- END_TF_DOCS -->