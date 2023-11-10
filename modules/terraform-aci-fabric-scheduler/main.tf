resource "aci_rest_managed" "trigSchedP" {
  dn         = "uni/fabric/schedp-${var.name}"
  class_name = "trigSchedP"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "trigRecurrWindowP" {
  for_each   = { for win in var.recurring_windows : win.name => win }
  dn         = "${aci_rest_managed.trigSchedP.dn}/recurrwinp-${each.value.name}"
  class_name = "trigRecurrWindowP"
  content = {
    name   = each.value.name
    day    = each.value.day
    hour   = each.value.hour
    minute = each.value.minute
  }
}
