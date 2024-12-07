<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Interfaces Policy Module

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_macsec_interfaces_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-interfaces-policy"
  version = ">= 0.9.2"

  name                     = "macsec-int-pol"
  admin_state              = true
  macsec_parameters_policy = "macsec-parameter-policy"
  macsec_keychain_policy   = "macsec-keychain-policy"
}
```
<!-- END_TF_DOCS -->