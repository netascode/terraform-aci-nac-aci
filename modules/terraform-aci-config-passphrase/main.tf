resource "aci_rest_managed" "pkiExportEncryptionKey" {
  dn         = "uni/exportcryptkey"
  class_name = "pkiExportEncryptionKey"
  content = {
    strongEncryptionEnabled = "yes"
    passphrase              = var.config_passphrase
  }

  lifecycle {
    ignore_changes = [content["passphrase"]]
  }
}
