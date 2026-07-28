locals {
  http_url  = var.http_url != "" ? (var.http_username != "" ? replace(var.http_url, "://", "://${var.http_username}:${var.http_password}@") : var.http_url) : ""
  https_url = var.https_url != "" ? (var.https_username != "" ? replace(var.https_url, "://", "://${var.https_username}:${var.https_password}@") : var.https_url) : ""
}

resource "aci_rest_managed" "proxyServer" {
  dn         = "uni/fabric/server"
  class_name = "proxyServer"
  content = {
    httpUrl  = local.http_url
    httpsUrl = local.https_url
  }
}

resource "aci_rest_managed" "proxyIgnoreHost" {
  for_each = toset(var.ignore_hosts)

  dn         = "${aci_rest_managed.proxyServer.dn}/ignorehost-${each.value}"
  class_name = "proxyIgnoreHost"
  content = {
    hosts = each.value
  }
}
