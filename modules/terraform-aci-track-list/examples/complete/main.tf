module "aci_track_list" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-track-list"
  version = ">= 0.8.0"

  tenant          = "ABC"
  name            = "TRACK1"
  description     = "My Description"
  percentage_down = 10
  percentage_up   = 20
  type            = "percentage"
  track_members   = ["mem1", "mem2"]
}
