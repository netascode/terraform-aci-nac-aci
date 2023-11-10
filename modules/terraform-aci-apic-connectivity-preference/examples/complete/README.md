<!-- BEGIN_TF_DOCS -->
# APIC Connectivity Preference Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_apic_connectivity_preference" {
  source  = "netascode/apic-connectivity-preference/aci"
  version = ">= 0.1.0"

  interface_preference = "ooband"
}
```
<!-- END_TF_DOCS -->