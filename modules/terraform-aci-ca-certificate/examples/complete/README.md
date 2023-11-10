<!-- BEGIN_TF_DOCS -->
# CA Certificate Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ca_certificate" {
  source  = "netascode/ca-certificate/aci"
  version = ">= 0.1.0"

  name              = "CA1"
  description       = "My Description"
  certificate_chain = <<-EOT
    -----BEGIN CERTIFICATE-----
    MIIC2jCCAcICCQDFcJLlj4fzhjANBgkqhkiG9w0BAQsFADAvMQswCQYDVQQGEwJE
    RTERMA8GA1UEBwwITGFMYUxhbmQxDTALBgNVBAoMBENTQ08wHhcNMjAwNzAxMTQw
    NjQ3WhcNMjYwMjA4MTQwNjQ3WjAvMQswCQYDVQQGEwJERTERMA8GA1UEBwwITGFM
    YUxhbmQxDTALBgNVBAoMBENTQ08wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
    AoIBAQCiq0iWqZwzsox8gEGo52Mk2iHbiKHMfXHYgWvzcOLMR2AHWjz5zcAtGW4J
    3yUcAP7SGYe7NvVwEc9D1TFOjaMz4dUPE9XhTBdvLpD2czfAWPa+5RakyvP7MsVN
    DPyI5mUnz6+5E5dunxXg8RgkzixO3qrjRCxm43L/yyBRr6N1h0D5Lh03WeZQc4gj
    X5R48ychf4uCLd/lPbBa3+5eLZaL+sOAH2Q/BPU12toqdSY9BpN5x11YJUZ/X2gr
    CQN443SrmcXdkb3ykF5JknbQhCuPW0X1grb8yko7DoQE6NP+TeT4K6aYtsVEvV2n
    Dldr6pRtKpJYwTuWrn8D06iIaaM/AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJ9f
    sTG4uuKYb737YKhwCxYoLAki58ofCCk2kQEUEFKXSHOX2QSvjtRhWl6g9AWO/SLG
    hOK2DQhwCcoR9zxfG/sWWc7zCdv8w1PXHtmBGqUZn76qXFF0G+nuY57XPJ0NKKj/
    G2Bs/g1TgyYzhErtxV/hmctgnnm4PfEQJYGNwCWkITxEg1lTQbN9JxsLpCZFldYW
    kE8Np68n0/ljx9ywqv0iUWkVDo30rs0Fo1uqDwHhAzuzRGFDrh97sAzVJ8ZH/Ge8
    Z0TC0TaX1BnUh5wsRz8hSlVAfgYQtQSarq9k9iLHDVcbffsYZbQKer6ftEGTTKOd
    DBPQR1dcBaa218Bjxl0=
    -----END CERTIFICATE-----
  EOT
}
```
<!-- END_TF_DOCS -->