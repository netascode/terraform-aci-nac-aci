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
  source  = "netascode/config-passphrase/aci"
  version = ">= 0.1.0"

  config_passphrase = "Cisco123!Cisco123!"
}
```
<!-- END_TF_DOCS -->