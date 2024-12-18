resource "aci_rest_managed" "mplsSrgbLabelPol" {
  dn         = "uni/tn-infra/mplslabelpol-default/mplssrgblabelpol-1"
  class_name = "mplsSrgbLabelPol"
  content = {
    localId      = 1
    minSrgbLabel = var.sr_global_block_minimum
    maxSrgbLabel = var.sr_global_block_maximum
  }
}
