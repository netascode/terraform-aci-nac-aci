<!-- BEGIN_TF_DOCS -->
# Terraform ACI Management Access Policy Module

Manages ACI Management Access Policy

Location in GUI:
`Fabric` » `Fabric Policies` » `Policies` » `Pod` » `Management Access`

## Examples

```hcl
module "aci_management_access_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-management-access-policy"
  version = ">= 0.8.0"

  name                         = "MAP1"
  description                  = "My Description"
  telnet_admin_state           = true
  telnet_port                  = 2023
  ssh_admin_state              = true
  ssh_password_auth            = true
  ssh_port                     = 2022
  ssh_aes128_ctr               = false
  ssh_aes128_gcm               = false
  ssh_aes192_ctr               = false
  ssh_aes256_ctr               = false
  ssh_aes256_gcm               = false
  ssh_chacha                   = false
  ssh_hmac_sha1                = false
  ssh_hmac_sha2_256            = false
  ssh_hmac_sha2_512            = false
  ssh_curve25519_sha256        = false
  ssh_curve25519_sha256_libssh = false
  ssh_dh1_sha1                 = false
  ssh_dh14_sha1                = false
  ssh_dh14_sha256              = false
  ssh_dh16_sha512              = false
  ssh_ecdh_sha2_nistp256       = false
  ssh_ecdh_sha2_nistp384       = false
  ssh_ecdh_sha2_nistp521       = false
  https_admin_state            = true
  https_client_cert_auth_state = false
  https_port                   = 2443
  https_dh                     = 2048
  https_tlsv1                  = true
  https_tlsv1_1                = true
  https_tlsv1_2                = false
  https_tlsv1_3                = false
  https_keyring                = "KR1"
  https_allow_origins          = "http://127.0.0.1:8000"
  http_admin_state             = true
  http_port                    = 2080
  http_allow_origins           = "http://127.0.0.1:8000"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Management access policy name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_telnet_admin_state"></a> [telnet\_admin\_state](#input\_telnet\_admin\_state) | Telnet admin state. | `bool` | `false` | no |
| <a name="input_telnet_port"></a> [telnet\_port](#input\_telnet\_port) | Telnet port. | `number` | `23` | no |
| <a name="input_ssh_admin_state"></a> [ssh\_admin\_state](#input\_ssh\_admin\_state) | SSH admin state. | `bool` | `true` | no |
| <a name="input_ssh_port"></a> [ssh\_port](#input\_ssh\_port) | SSH port. | `number` | `22` | no |
| <a name="input_ssh_password_auth"></a> [ssh\_password\_auth](#input\_ssh\_password\_auth) | SSH password authentication. | `bool` | `true` | no |
| <a name="input_ssh_aes128_ctr"></a> [ssh\_aes128\_ctr](#input\_ssh\_aes128\_ctr) | aes128-ctr cipher. | `bool` | `true` | no |
| <a name="input_ssh_aes128_gcm"></a> [ssh\_aes128\_gcm](#input\_ssh\_aes128\_gcm) | aes128-gcm cipher. | `bool` | `true` | no |
| <a name="input_ssh_aes192_ctr"></a> [ssh\_aes192\_ctr](#input\_ssh\_aes192\_ctr) | aes192-ctr cipher. | `bool` | `true` | no |
| <a name="input_ssh_aes256_ctr"></a> [ssh\_aes256\_ctr](#input\_ssh\_aes256\_ctr) | aes256-ctr cipher. | `bool` | `true` | no |
| <a name="input_ssh_aes256_gcm"></a> [ssh\_aes256\_gcm](#input\_ssh\_aes256\_gcm) | aes256-gcm cipher. | `bool` | `false` | no |
| <a name="input_ssh_chacha"></a> [ssh\_chacha](#input\_ssh\_chacha) | chacha cipher. | `bool` | `true` | no |
| <a name="input_ssh_hmac_sha1"></a> [ssh\_hmac\_sha1](#input\_ssh\_hmac\_sha1) | hmac-sha1 message authentication code. | `bool` | `true` | no |
| <a name="input_ssh_hmac_sha2_256"></a> [ssh\_hmac\_sha2\_256](#input\_ssh\_hmac\_sha2\_256) | hmac-sha2-256 message authentication code. | `bool` | `true` | no |
| <a name="input_ssh_hmac_sha2_512"></a> [ssh\_hmac\_sha2\_512](#input\_ssh\_hmac\_sha2\_512) | hmac-sha2-512 message authentication code. | `bool` | `true` | no |
| <a name="input_ssh_curve25519_sha256"></a> [ssh\_curve25519\_sha256](#input\_ssh\_curve25519\_sha256) | curve25519-sha256 kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_curve25519_sha256_libssh"></a> [ssh\_curve25519\_sha256\_libssh](#input\_ssh\_curve25519\_sha256\_libssh) | curve25519-sha256 libssh.org kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_dh1_sha1"></a> [ssh\_dh1\_sha1](#input\_ssh\_dh1\_sha1) | diffie-hellman-group1-sha1 kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_dh14_sha1"></a> [ssh\_dh14\_sha1](#input\_ssh\_dh14\_sha1) | diffie-hellman-group14-sha1 kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_dh14_sha256"></a> [ssh\_dh14\_sha256](#input\_ssh\_dh14\_sha256) | diffie-hellman-group14-sha256 kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_dh16_sha512"></a> [ssh\_dh16\_sha512](#input\_ssh\_dh16\_sha512) | diffie-hellman-group16-sha512 kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_ecdh_sha2_nistp256"></a> [ssh\_ecdh\_sha2\_nistp256](#input\_ssh\_ecdh\_sha2\_nistp256) | ecdh-sha2-nistp256 kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_ecdh_sha2_nistp384"></a> [ssh\_ecdh\_sha2\_nistp384](#input\_ssh\_ecdh\_sha2\_nistp384) | ecdh-sha2-nistp384 kex algorithm. | `bool` | `false` | no |
| <a name="input_ssh_ecdh_sha2_nistp521"></a> [ssh\_ecdh\_sha2\_nistp521](#input\_ssh\_ecdh\_sha2\_nistp521) | ecdh-sha2-nistp521 kex algorithm. | `bool` | `false` | no |
| <a name="input_https_admin_state"></a> [https\_admin\_state](#input\_https\_admin\_state) | HTTPS admin state. | `bool` | `false` | no |
| <a name="input_https_client_cert_auth_state"></a> [https\_client\_cert\_auth\_state](#input\_https\_client\_cert\_auth\_state) | HTTPS client certificate authentication state. | `bool` | `false` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | HTTPS port. | `number` | `443` | no |
| <a name="input_https_dh"></a> [https\_dh](#input\_https\_dh) | HTTPS Diffie-Hellman group. Choices: `1024`, `2048`, `4096` or `none`. | `string` | `"none"` | no |
| <a name="input_https_tlsv1"></a> [https\_tlsv1](#input\_https\_tlsv1) | HTTPS TLS v1. | `bool` | `false` | no |
| <a name="input_https_tlsv1_1"></a> [https\_tlsv1\_1](#input\_https\_tlsv1\_1) | HTTPS TLS v1.1. | `bool` | `true` | no |
| <a name="input_https_tlsv1_2"></a> [https\_tlsv1\_2](#input\_https\_tlsv1\_2) | HTTPS TLS v1.2. | `bool` | `true` | no |
| <a name="input_https_tlsv1_3"></a> [https\_tlsv1\_3](#input\_https\_tlsv1\_3) | HTTPS TLS v1.3. | `bool` | `false` | no |
| <a name="input_https_keyring"></a> [https\_keyring](#input\_https\_keyring) | HTTPS keyring name. | `string` | `""` | no |
| <a name="input_https_allow_origins"></a> [https\_allow\_origins](#input\_https\_allow\_origins) | HTTPS allow origins. | `string` | `""` | no |
| <a name="input_http_admin_state"></a> [http\_admin\_state](#input\_http\_admin\_state) | HTTP admin state. | `bool` | `false` | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | HTTP port. | `number` | `80` | no |
| <a name="input_http_allow_origins"></a> [http\_allow\_origins](#input\_http\_allow\_origins) | HTTP allow origins. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `commPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Management access policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.commHttp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.commHttps](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.commPol](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.commRsKeyRing](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.commSsh](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.commTelnet](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->