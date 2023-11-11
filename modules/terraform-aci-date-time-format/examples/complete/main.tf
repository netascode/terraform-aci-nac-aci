module "aci_date_time_format" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-date-time-format"
  version = ">= 0.8.0"

  display_format = "utc"
  timezone       = "p120_Europe-Vienna"
  show_offset    = false
}
