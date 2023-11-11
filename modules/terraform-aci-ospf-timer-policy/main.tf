resource "aci_rest_managed" "ospfCtxPol" {
  dn         = "uni/tn-${var.tenant}/ospfCtxP-${var.name}"
  class_name = "ospfCtxPol"
  content = {
    name             = var.name
    descr            = var.description
    bwRef            = var.reference_bandwidth
    dist             = var.distance
    grCtrl           = var.graceful_restart == true ? "helper" : ""
    lsaArrivalIntvl  = var.lsa_arrival_interval
    lsaGpPacingIntvl = var.lsa_group_pacing_interval
    lsaHoldIntvl     = var.lsa_hold_interval
    lsaMaxIntvl      = var.lsa_max_interval
    lsaStartIntvl    = var.lsa_start_interval
    maxEcmp          = var.max_ecmp
    maxLsaAction     = var.max_lsa_action
    maxLsaResetIntvl = var.max_lsa_reset_interval
    maxLsaSleepCnt   = var.max_lsa_sleep_count
    maxLsaSleepIntvl = var.max_lsa_sleep_interval
    maxLsaNum        = var.max_lsa_num
    maxLsaThresh     = var.max_lsa_threshold
    spfHoldIntvl     = var.spf_hold_interval
    spfInitIntvl     = var.spf_init_interval
    spfMaxIntvl      = var.spf_max_interval
    ctrl             = join(",", concat(var.router_id_lookup == true ? ["name-lookup"] : [], var.prefix_suppression == true ? ["pfx-suppress"] : []))
  }
}
