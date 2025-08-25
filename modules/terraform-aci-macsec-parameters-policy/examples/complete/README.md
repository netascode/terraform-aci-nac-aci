<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Parameters Policy Module

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_macsec_parameters_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-parameters-policy"
  version = ">= 0.9.2"

  name                   = "macsecparam1"
  description            = "macsecparam1 description"
  confidentiality_offset = "offset-30"
  key_server_priority    = 128
  cipher_suite           = "gcm-aes-128"
  window_size            = 1024
  key_expiry_time        = 120
  security_policy        = "must-secure"
}
```
<!-- END_TF_DOCS -->