<!-- BEGIN_TF_DOCS -->
# Link Level Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_link_level_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-link-level-policy"
  version = ">= 0.8.0"

  name             = "100G"
  speed            = "100G"
  link_delay_ms    = 10
  link_debounce_ms = 110
  auto             = true
  fec_mode         = "disable-fec"
}
```
<!-- END_TF_DOCS -->