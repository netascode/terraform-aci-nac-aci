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
  source  = "netascode/nac-aci/aci//modules/terraform-aci-apic-connectivity-preference"
  version = ">= 0.8.0"

  interface_preference = "ooband"
}
```
<!-- END_TF_DOCS -->