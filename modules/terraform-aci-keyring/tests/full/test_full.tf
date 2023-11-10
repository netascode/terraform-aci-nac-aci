terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "pkiTP" {
  dn         = "uni/userext/pkiext/tp-CA1"
  class_name = "pkiTP"
  content = {
    name      = "CA1"
    certChain = <<-EOT
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

  lifecycle {
    ignore_changes = [content["certChain"]]
  }
}

module "main" {
  source = "../.."

  name           = "KEYRING1"
  description    = "My Description"
  ca_certificate = aci_rest_managed.pkiTP.content.name
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

data "aci_rest_managed" "pkiKeyRing" {
  dn = "uni/userext/pkiext/keyring-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "pkiKeyRing" {
  component = "pkiKeyRing"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.pkiKeyRing.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.pkiKeyRing.content.descr
    want        = "My Description"
  }

  equal "tp" {
    description = "tp"
    got         = data.aci_rest_managed.pkiKeyRing.content.tp
    want        = "CA1"
  }
}
