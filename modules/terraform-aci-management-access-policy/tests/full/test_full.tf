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
  ssh_chacha                   = true
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
  http_admin_state             = true
  http_port                    = 2080
}

data "aci_rest_managed" "commPol" {
  dn = "uni/fabric/comm-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "commPol" {
  component = "commPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.commPol.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.commPol.content.descr
    want        = "My Description"
  }
}

data "aci_rest_managed" "commTelnet" {
  dn = "${data.aci_rest_managed.commPol.id}/telnet"

  depends_on = [module.main]
}

resource "test_assertions" "commTelnet" {
  component = "commTelnet"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.commTelnet.content.name
    want        = "telnet"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.commTelnet.content.adminSt
    want        = "enabled"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.commTelnet.content.port
    want        = "2023"
  }
}

data "aci_rest_managed" "commSsh" {
  dn = "${data.aci_rest_managed.commPol.id}/ssh"

  depends_on = [module.main]
}

resource "test_assertions" "commSsh" {
  component = "commSsh"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.commSsh.content.name
    want        = "ssh"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.commSsh.content.adminSt
    want        = "enabled"
  }

  equal "passwordAuth" {
    description = "passwordAuth"
    got         = data.aci_rest_managed.commSsh.content.passwordAuth
    want        = "enabled"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.commSsh.content.port
    want        = "2022"
  }

  equal "sshCiphers" {
    description = "sshCiphers"
    got         = data.aci_rest_managed.commSsh.content.sshCiphers
    want        = "chacha20-poly1305@openssh.com"
  }

  equal "sshMacs" {
    description = "sshMacs"
    got         = data.aci_rest_managed.commSsh.content.sshMacs
    want        = ""
  }
}

data "aci_rest_managed" "commHttps" {
  dn = "${data.aci_rest_managed.commPol.id}/https"

  depends_on = [module.main]
}

resource "test_assertions" "commHttps" {
  component = "commHttps"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.commHttps.content.name
    want        = "https"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.commHttps.content.adminSt
    want        = "enabled"
  }

  equal "clientCertAuthState" {
    description = "clientCertAuthState"
    got         = data.aci_rest_managed.commHttps.content.clientCertAuthState
    want        = "disabled"
  }

  equal "dhParam" {
    description = "dhParam"
    got         = data.aci_rest_managed.commHttps.content.dhParam
    want        = "2048"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.commHttps.content.port
    want        = "2443"
  }

  equal "sslProtocols" {
    description = "sslProtocols"
    got         = data.aci_rest_managed.commHttps.content.sslProtocols
    want        = "TLSv1,TLSv1.1"
  }

  equal "visoreAccess" {
    description = "visoreAccess"
    got         = data.aci_rest_managed.commHttps.content.visoreAccess
    want        = "enabled"
  }
}

data "aci_rest_managed" "commRsKeyRing" {
  dn = "${data.aci_rest_managed.commHttps.id}/rsKeyRing"

  depends_on = [module.main]
}

resource "test_assertions" "commRsKeyRing" {
  component = "commRsKeyRing"

  equal "tnPkiKeyRingName" {
    description = "tnPkiKeyRingName"
    got         = data.aci_rest_managed.commRsKeyRing.content.tnPkiKeyRingName
    want        = "KR1"
  }
}

data "aci_rest_managed" "commHttp" {
  dn = "${data.aci_rest_managed.commPol.id}/http"

  depends_on = [module.main]
}

resource "test_assertions" "commHttp" {
  component = "commHttp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.commHttp.content.name
    want        = "http"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.commHttp.content.adminSt
    want        = "enabled"
  }

  equal "port" {
    description = "port"
    got         = data.aci_rest_managed.commHttp.content.port
    want        = "2080"
  }

  equal "visoreAccess" {
    description = "visoreAccess"
    got         = data.aci_rest_managed.commHttp.content.visoreAccess
    want        = "enabled"
  }
}
