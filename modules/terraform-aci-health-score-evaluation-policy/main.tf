resource "aci_rest_managed" "healthEvalP" {
  dn         = "uni/fabric/hsPols/hseval"
  class_name = "healthEvalP"
  content = {
    ignoreAckedFaults = var.ignore_acked_faults ? "yes" : "no"
  }
}
