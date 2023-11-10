resource "aci_rest_managed" "pkiKeyRing" {
  dn         = "uni/userext/pkiext/keyring-${var.name}"
  class_name = "pkiKeyRing"
  content = {
    name  = var.name
    descr = var.description
    tp    = var.ca_certificate
    cert  = var.certificate
    key   = var.private_key
  }

  lifecycle {
    ignore_changes = [content["cert"], content["key"]]
  }
}
