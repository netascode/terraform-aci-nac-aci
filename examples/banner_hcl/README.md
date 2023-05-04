<!-- BEGIN_TF_DOCS -->
# Banner Example
To run this example you need to execute:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `main.tf`

```hcl
module "banner" {
  source  = "netascode/nac-aci/aci"
  version = ">= 0.7.0"

  model = {
    apic = {
      fabric_policies = {
        banners = {
          apic_cli_banner = "My APIC Banner"
        }
      }
    }
  }

  manage_fabric_policies = true
}
```
<!-- END_TF_DOCS -->