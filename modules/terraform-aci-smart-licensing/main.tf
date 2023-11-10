resource "aci_rest_managed" "licenseLicPolicy" {
  dn         = "uni/fabric/licensepol"
  class_name = "licenseLicPolicy"
  content = {
    ipAddr        = var.proxy_hostname_ip
    mode          = var.mode
    port          = var.proxy_port
    regTokenId    = var.registration_token
    url           = var.url
    regAdminState = "register"
  }

  lifecycle {
    ignore_changes = [content["regAdminState"], content["regTokenId"]]
  }
}

