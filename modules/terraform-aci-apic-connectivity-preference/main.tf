resource "aci_rest_managed" "mgmtConnectivityPrefs" {
  dn         = "uni/fabric/connectivityPrefs"
  class_name = "mgmtConnectivityPrefs"
  content = {
    interfacePref = var.interface_preference
  }
}
