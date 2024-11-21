<!-- BEGIN_TF_DOCS -->
# Terraform ACI Keyring Module

Manages ACI Keyring

Location in GUI:
`Admin` » `AAA` » `Security` » `Public Key Management` » `Key Rings`

## Examples

```hcl
module "aci_keyring" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-keyring"
  version = ">= 0.8.0"

  name           = "KEYRING1"
  description    = "My Description"
  ca_certificate = "CA1"
  certificate    = <<-EOT
    -----BEGIN CERTIFICATE-----
    MIICyzCCAbMCCQCUc/SvuffglTANBgkqhkiG9w0BAQsFADAvMQswCQYDVQQGEwJE
    RTERMA8GA1UEBwwITGFMYUxhbmQxDTALBgNVBAoMBENTQ08wHhcNMjAwNzAxMTQw
    ODI1WhcNMjYwMjA4MTQwODI1WjAgMQswCQYDVQQGEwJERTERMA8GA1UEBwwITGFM
    YUxhbmQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC2KTuvhTSK3bYC
    8thn47aI6Hj0HLLDkqS72M7KSF6kCEFn2lxC8yKQ1PpHEyRxEeqKD5+V3ndC5Nun
    wqRPwA+qHyAJ+qKMqrmbE98KxuKeavyGfroLvMYRb7UUnCPsLOUpwimm3jWw2Jvz
    Mevb8q5kXJuPPWGIZ6DoUliJKRwiW62qlY/zq+wbweij4NzzMM+Xiaw9KzGnn0GY
    meeKEDdO4Q0gLo89FLXpoEBptfhqYWWqrlQNYUizew7MCKhYNjOn8D/clvD7Qynn
    kFlHEnAugR8TWgXiujZAZuUFvImu++KDdzCX1PTa7Q1NN1hjuaK1WgEqeUEQWmOD
    68FdILFrAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAA7BcY4rMsc2kggoZ6MQv0Pc
    lPpM+cowoRWhUaKMveLrUJoAtUshLn8MneDWopPFx2tXWw+RfBlsbcQUWkonEFb1
    oVdbBIoLT3VH/VKDUNdYa43KuugKe2nCba7Fpya54HCC2jtIv+W7SIZuAhu1937x
    OF3O8itHhBMW5/teX/Uo3JPjE4JoFPoQ7P6KmertvWAIFvQB/1oFQhJ6rmkNYjKY
    f4n71cuGmduTWzKv7UoG4nf5YoKC0tZQfOCYU9W7ywnvJThaSN0ZUf3Dqa2WB4Zx
    91bgkeI6vpJLPnjyAsmbNRePNj1xgXC5YMcN5LiGhsMiep9yBqJR1Knq80J0DwE=
    -----END CERTIFICATE-----
  EOT
  private_key    = <<-EOT
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEAtik7r4U0it22AvLYZ+O2iOh49Byyw5Kku9jOykhepAhBZ9pc
    QvMikNT6RxMkcRHqig+fld53QuTbp8KkT8APqh8gCfqijKq5mxPfCsbinmr8hn66
    C7zGEW+1FJwj7CzlKcIppt41sNib8zHr2/KuZFybjz1hiGeg6FJYiSkcIlutqpWP
    86vsG8Hoo+Dc8zDPl4msPSsxp59BmJnnihA3TuENIC6PPRS16aBAabX4amFlqq5U
    DWFIs3sOzAioWDYzp/A/3Jbw+0Mp55BZRxJwLoEfE1oF4ro2QGblBbyJrvvig3cw
    l9T02u0NTTdYY7mitVoBKnlBEFpjg+vBXSCxawIDAQABAoIBAQCKtjFWAdg12ojM
    DAKQcc1Ayc25DdVuqc85n+owDRXMUOEFZTkWXjC3GwcOclwwodT4ltcN957XWJCP
    Wd9nPzhuck8iajG3bhXyKhqRCUvuGEf9XqjrYS9ufaLlc9TC9pj2yHyRLeqypO90
    LFKPZWg40nA+jh4kEc1su6/hmmVrHxwUdf7bdZwYqBW3xedQGWHZtZxmbY8pLT7n
    iJnv/EC8mrAQdxiNOcO9z2aWQY14hBsqD2hQkjSSVuhAnzeonU9VrCg0v/VQmX+/
    VhGF48aVQbG1yfh0IxBbX2tbl1tSvh2Vtb6r29mywKRDaKmxRd/Qr6iImSM8A/fz
    m6UpLTzRAoGBAO/zIpxan454J9qh4qaPybhdBwfUMr4HAJtUiWJnLJ2CMvJa8rOA
    Xf7QS9ddTE78rUSe1dS2a/RUJ/a1JwI5rj3Un2C9L13YXmWwRHolsjz/lC1pDC87
    sqDG/PT4y5qxQ8r5zJ5+XaJxN37ojtHZipfIYuVAlH+whlInWoUgq6dzAoGBAMJY
    iG7sxLx8mXE+U2630HIbTw/jZwKUVPcjMMYDqc97qfDgAVFN3lkKxqHjSW7bUsdF
    DLiwuzlluVuRiAFRFwy256P8yHhfHigCzKuFLGhXuzTGdn7gdvlKsXfgPKOIMcHx
    lpAPU7lIIh3xmoVUWWtHqXGMXqY2Jz3f5BJWWaApAoGAHvAYbFR68iGn8dahpJwx
    hCXqfCXuDPZWK7DwrdFjvUNGUl1Lob1RYUN2I+SRrDWEGa7pHy4OKUiYhoTA7NaH
    Es3RZuW9r7nwIehiS+WEX70MW/aJbaWi2HwPrX5Osjlc5lTi/ySH6iPy5dgSYhhM
    eFmL9scm3nfiOcF9OGEIAOUCgYBmrN9nuy81ZZ6rdYIevH4jysm6WynQ8wzwhGcA
    Nm9AbtUZrT8E9V7DLC5E2Q+yway6GoDeEoDXkiabegegqnbDAN7ghGxlK9uCx/fZ
    pkIP3knJWBDCd1Rj4FJiQtXGj+25ySkCcxaIjNN5fmtkhWu4gePDWaWnqnSQ+/hC
    t9wiAQKBgQCkVuIjhK82p3OJXZPaq8jrGy8hvHM02zj9tZxK98wDApafZBA4VRW+
    KAh7qxM2mhQsDwKplp5noW9pXlQfgBniDmCFK/4xcEaD+UwYF/Ao7RlLjLL2MfsP
    40igT6oadbESZNx815FBttdPkKc3zWRgv40MdZNdTQ9BlShqN9jTQw==
    -----END RSA PRIVATE KEY-----
  EOT
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
| <a name="input_name"></a> [name](#input\_name) | Keyring name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_ca_certificate"></a> [ca\_certificate](#input\_ca\_certificate) | CA certificate name. | `string` | `""` | no |
| <a name="input_certificate"></a> [certificate](#input\_certificate) | Certificate. | `string` | `""` | no |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Private key. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `pkiKeyRing` object. |
| <a name="output_name"></a> [name](#output\_name) | Keyring name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.pkiKeyRing](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->