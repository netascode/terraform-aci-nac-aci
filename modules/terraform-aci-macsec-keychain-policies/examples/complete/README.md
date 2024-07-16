<!-- BEGIN_TF_DOCS -->
# Terraform ACI MACsec Keychain Policies Module

Manages ACI MACsec Keychain Policy

Location in GUI:
`Fabric` » `Access Policies` » `Policies` » `Interface` » `MACsec` » `MACsec KeyChain Policies`

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_macsec_keychain_policies" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-macsec-keychain-policies"
  version = ">= 0.8.0"

  name        = "macsec-keychain-pol"
  description = "Keychain Description"
  key_policies = [{
    name         = "keypolicy1"
    description  = "Key Policy Description"
    keyName      = "deadbeef9898765431"
    preSharedKey = "abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234"
    startTime    = "now"
    endTime      = "infinite"
  }]
}
```
<!-- END_TF_DOCS -->