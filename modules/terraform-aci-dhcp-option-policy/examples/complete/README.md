<!-- BEGIN_TF_DOCS -->
# DHCP Option Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_dhcp_option_policy" {
  source  = "netascode/dhcp-option-policy/aci"
  version = ">= 0.2.0"

  tenant      = "ABC"
  name        = "DHCP-OPTION1"
  description = "My Description"
  options = [{
    id   = 1
    data = "DATA1"
    name = "OPTION1"
  }]
}
```
<!-- END_TF_DOCS -->