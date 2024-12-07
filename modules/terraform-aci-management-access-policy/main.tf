locals {
  ssh_kexalgos = join(",", concat(var.ssh_curve25519_sha256 == true ? ["curve25519-sha256"] : [], var.ssh_curve25519_sha256_libssh == true ? ["curve25519-sha256@libssh.org"] : [], var.ssh_dh1_sha1 == true ? ["diffie-hellman-group1-sha1"] : [], var.ssh_dh14_sha1 == true ? ["diffie-hellman-group14-sha1"] : [], var.ssh_dh14_sha256 == true ? ["diffie-hellman-group14-sha256"] : [], var.ssh_dh16_sha512 == true ? ["diffie-hellman-group16-sha512"] : [], var.ssh_ecdh_sha2_nistp256 == true ? ["ecdh-sha2-nistp256"] : [], var.ssh_ecdh_sha2_nistp384 == true ? ["ecdh-sha2-nistp384"] : [], var.ssh_ecdh_sha2_nistp521 == true ? ["ecdh-sha2-nistp521"] : []))
}

resource "aci_rest_managed" "commPol" {
  dn         = "uni/fabric/comm-${var.name}"
  class_name = "commPol"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "commTelnet" {
  dn         = "${aci_rest_managed.commPol.dn}/telnet"
  class_name = "commTelnet"
  content = {
    name    = "telnet"
    adminSt = var.telnet_admin_state == true ? "enabled" : "disabled"
    port    = var.telnet_port
  }
}

resource "aci_rest_managed" "commSsh" {
  dn         = "${aci_rest_managed.commPol.dn}/ssh"
  class_name = "commSsh"
  content = {
    name         = "ssh"
    adminSt      = var.ssh_admin_state == false ? "disabled" : "enabled"
    passwordAuth = var.ssh_password_auth == false ? "disabled" : "enabled"
    port         = var.ssh_port
    sshCiphers   = join(",", concat(var.ssh_aes128_ctr == true ? ["aes128-ctr"] : [], var.ssh_aes128_gcm == true ? ["aes128-gcm@openssh.com"] : [], var.ssh_aes192_ctr == true ? ["aes192-ctr"] : [], var.ssh_aes256_ctr == true ? ["aes256-ctr"] : [], var.ssh_aes256_gcm == true ? ["aes256-gcm@openssh.com"] : [], var.ssh_chacha == true ? ["chacha20-poly1305@openssh.com"] : []))
    sshMacs      = join(",", concat(var.ssh_hmac_sha1 == true ? ["hmac-sha1"] : [], var.ssh_hmac_sha2_256 == true ? ["hmac-sha2-256"] : [], var.ssh_hmac_sha2_512 == true ? ["hmac-sha2-512"] : []))
    kexAlgos     = length(local.ssh_kexalgos) == 0 ? null : local.ssh_kexalgos
  }
}

resource "aci_rest_managed" "commHttps" {
  dn         = "${aci_rest_managed.commPol.dn}/https"
  class_name = "commHttps"
  content = {
    name                      = "https"
    accessControlAllowOrigins = var.https_allow_origins
    adminSt                   = var.https_admin_state == false ? "disabled" : "enabled"
    clientCertAuthState       = var.https_client_cert_auth_state == true ? "enabled" : "disabled"
    dhParam                   = var.https_dh
    port                      = var.https_port
    sslProtocols              = join(",", concat(var.https_tlsv1 == true ? ["TLSv1"] : [], var.https_tlsv1_1 == true ? ["TLSv1.1"] : [], var.https_tlsv1_2 == true ? ["TLSv1.2"] : [], var.https_tlsv1_3 == true ? ["TLSv1.3"] : []))
    visoreAccess              = "enabled"
  }
}

resource "aci_rest_managed" "commRsKeyRing" {
  dn         = "${aci_rest_managed.commHttps.dn}/rsKeyRing"
  class_name = "commRsKeyRing"
  content = {
    tnPkiKeyRingName = var.https_keyring != "" ? var.https_keyring : "default"
  }
}

resource "aci_rest_managed" "commHttp" {
  dn         = "${aci_rest_managed.commPol.dn}/http"
  class_name = "commHttp"
  content = {
    name                      = "http"
    accessControlAllowOrigins = var.http_allow_origins
    adminSt                   = var.http_admin_state == true ? "enabled" : "disabled"
    port                      = var.http_port
    visoreAccess              = "enabled"
  }
}
