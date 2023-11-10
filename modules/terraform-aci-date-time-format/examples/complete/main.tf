module "aci_date_time_format" {
  source  = "netascode/date-time-format/aci"
  version = ">= 0.1.0"

  display_format = "utc"
  timezone       = "p120_Europe-Vienna"
  show_offset    = false
}
