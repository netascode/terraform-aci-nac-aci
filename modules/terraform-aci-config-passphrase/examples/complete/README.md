<!-- BEGIN_TF_DOCS -->
# ACI Config Passphrase Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_config_passphrase" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-config-passphrase"
  version = ">= 0.8.0"

  config_passphrase = "Cisco123!Cisco123!"
}
```
<!-- END_TF_DOCS -->