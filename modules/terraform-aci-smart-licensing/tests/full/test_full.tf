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

module "main" {
  source = "../.."

  mode               = "proxy"
  registration_token = "ABCDEFG"
  proxy_hostname_ip  = "a.proxy.com"
  proxy_port         = "80"
  url                = "https://tools.cisco.com/its/service/oddce/services/DDCEService"
}

data "aci_rest_managed" "licenseLicPolicy" {
  dn = "uni/fabric/licensepol"

  depends_on = [module.main]
}

resource "test_assertions" "licenseLicPolicy" {
  component = "licenseLicPolicy"

  equal "mode" {
    description = "mode"
    got         = data.aci_rest_managed.licenseLicPolicy.content.mode
    want        = "proxy"
  }

  equal "ipAddr" {
    description = "Proxy Hostname or IP"
    got         = data.aci_rest_managed.licenseLicPolicy.content.ipAddr
    want        = "a.proxy.com"
  }

  equal "port" {
    description = "Proxy port"
    got         = data.aci_rest_managed.licenseLicPolicy.content.port
    want        = "80"
  }
}
