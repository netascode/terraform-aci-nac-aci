<!-- BEGIN_TF_DOCS -->
# Terraform ACI Remote Location Module

Manages ACI Remote Location

Location in GUI:
`Admin` » `Import/Export` » `Remote Locations`

## Examples

```hcl
module "aci_remote_location" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-remote-location"
  version = ">= 0.8.0"

  name          = "RL1"
  description   = "My Description"
  hostname_ip   = "1.1.1.1"
  auth_type     = "password"
  protocol      = "ftp"
  path          = "/"
  port          = 21
  username      = "user1"
  password      = "password"
  mgmt_epg_type = "oob"
  mgmt_epg_name = "OOB1"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.15.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Remote location name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_hostname_ip"></a> [hostname\_ip](#input\_hostname\_ip) | Hostname or IP. | `string` | n/a | yes |
| <a name="input_auth_type"></a> [auth\_type](#input\_auth\_type) | Authentication type. Choices: `password`, `ssh_keys`. | `string` | `"password"` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | Protocol. Choices: `ftp`, `sftp`, `scp`. | `string` | `"sftp"` | no |
| <a name="input_path"></a> [path](#input\_path) | Path. | `string` | `""` | no |
| <a name="input_port"></a> [port](#input\_port) | Port. Allowed values: 0-65535. | `number` | `0` | no |
| <a name="input_username"></a> [username](#input\_username) | Username. | `string` | `""` | no |
| <a name="input_password"></a> [password](#input\_password) | Password. | `string` | `""` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | SSH private key. | `string` | `""` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key. | `string` | `""` | no |
| <a name="input_ssh_passphrase"></a> [ssh\_passphrase](#input\_ssh\_passphrase) | SSH passphrase. | `string` | `""` | no |
| <a name="input_mgmt_epg_type"></a> [mgmt\_epg\_type](#input\_mgmt\_epg\_type) | Management EPG type. Choices: `inb`, `oob`. | `string` | `"inb"` | no |
| <a name="input_mgmt_epg_name"></a> [mgmt\_epg\_name](#input\_mgmt\_epg\_name) | Management EPG name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fileRemotePath` object. |
| <a name="output_name"></a> [name](#output\_name) | Remote location name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.fileRemotePath](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fileRsARemoteHostToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->