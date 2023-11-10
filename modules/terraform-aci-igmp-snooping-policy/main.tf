resource "aci_rest_managed" "igmpSnoopPol" {
  dn         = "uni/tn-${var.tenant}/snPol-${var.name}"
  class_name = "igmpSnoopPol"
  content = {
    name            = var.name
    descr           = var.description
    adminSt         = var.admin_state == true ? "enabled" : "disabled"
    ctrl            = join(",", concat(var.fast_leave == true ? ["fast-leave"] : [], var.querier == true ? ["querier"] : []))
    lastMbrIntvl    = var.last_member_query_interval
    queryIntvl      = var.query_interval
    rspIntvl        = var.query_response_interval
    startQueryCnt   = var.start_query_count
    startQueryIntvl = var.start_query_interval
  }
}
