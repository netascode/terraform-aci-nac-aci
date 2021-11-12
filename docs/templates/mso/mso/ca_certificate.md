# CA Certificate

This is only supported for VM and ASE (Application Service Engine) based deployments. Deployments based on Nexus Dashboard do not support this feature.

Location in GUI:
`Admin` » `Security` » `Certificate Authority`

{{ aac_doc }}
### Examples

```yaml
mso:
  ca_certificates:
    - name: CERT1
      description: Description
      public_key: -----BEGIN CERTIFICATE-----\nMIIB8TCCAVoCCQC1fWFVBBN/BDANBgkqhkiG9w0BAQsFADA8MRAwDgYDVQQDDAdh\nbnNpYmxlMQ4wDAYDVQQKDAVDaXNjbzELMAkGA1UECwwCQ1gxCzAJBgNVBAYTAlVT\nMCAXDTE5MDUxNDE4Mzc0NVoYDzIxMTkwNDIwMTgzNzQ1WjA8MRAwDgYDVQQDDAdh\nbnNpYmxlMQ4wDAYDVQQKDAVDaXNjbzELMAkGA1UECwwCQ1gxCzAJBgNVBAYTAlVT\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDU5ZySFa/ToZgF53wwlgl8CRzX\nbkHsNSxAnaWdBda4Hw9+qp+IbZcJB93Y1c4BprvEXU0FRkvqoe7r4Yy/qKme85If\nmYbEcXYqxJEA1z28nQJKIplVo8LNB746FkcA8+An9e0jUM3MqHsW4kQUBRvoiv55\n4/VUfxJ6LNN4lokX1wIDAQABMA0GCSqGSIb3DQEBCwUAA4GBAFVPScMEESle01WX\nGASnupBAgX3NnJuSKo/ReOzagFjZj4RqmaE2XgoHfMjb7/wHfNsuDB3aZ/6gg22c\nARrqj23UtwyWtgVjzLipaqmfDLXtQe54qO81rMsd6wnhy9AUZwPbnELe4tcrQrlM\nkhsvmhqSFHxtVsIzJgwUs4kGU39i\n-----END CERTIFICATE-----
```
