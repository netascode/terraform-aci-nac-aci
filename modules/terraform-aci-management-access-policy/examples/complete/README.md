<!-- BEGIN_TF_DOCS -->
# Management Access Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
<!-- END_TF_DOCS -->