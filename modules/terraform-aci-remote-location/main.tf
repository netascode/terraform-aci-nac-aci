resource "aci_rest_managed" "fileRemotePath" {
  dn          = "uni/fabric/path-${var.name}"
  class_name  = "fileRemotePath"
  escape_html = false
  content = {
    name                         = var.name
    host                         = var.hostname_ip
    descr                        = var.description
    authType                     = var.auth_type == "ssh_keys" ? "useSshKeyContents" : "usePassword"
    protocol                     = var.protocol
    remotePath                   = var.path
    remotePort                   = var.port
    userName                     = var.username != "" ? var.username : null
    userPasswd                   = var.password != "" ? var.password : null
    identityPrivateKeyContents   = var.ssh_private_key != "" ? var.ssh_private_key : null
    identityPublicKeyContents    = var.ssh_public_key != "" ? var.ssh_public_key : null
    identityPrivateKeyPassphrase = var.ssh_passphrase != "" ? var.ssh_passphrase : null
  }

  lifecycle {
    ignore_changes = [content["userPasswd"], content["identityPrivateKeyContents"], content["identityPublicKeyContents"], content["identityPrivateKeyPassphrase"]]
  }
}

resource "aci_rest_managed" "fileRsARemoteHostToEpg" {
  dn         = "${aci_rest_managed.fileRemotePath.dn}/rsARemoteHostToEpg"
  class_name = "fileRsARemoteHostToEpg"
  content = {
    tDn = var.mgmt_epg_type == "oob" ? "uni/tn-mgmt/mgmtp-default/oob-${var.mgmt_epg_name}" : "uni/tn-mgmt/mgmtp-default/inb-${var.mgmt_epg_name}"
  }
}
