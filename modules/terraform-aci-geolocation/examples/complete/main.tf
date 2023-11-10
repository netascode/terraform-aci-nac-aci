module "aci_geolocation" {
  source  = "netascode/geolocation/aci"
  version = ">= 0.2.0"

  name        = "SITE1"
  description = "Site Description"
  buildings = [{
    name        = "BUILDING1"
    description = "Building Description"
    floors = [{
      name        = "FLOOR1"
      description = "Floor Description"
      rooms = [{
        name        = "ROOM1"
        description = "Room Description"
        rows = [{
          name        = "ROW1"
          description = "Row Description"
          racks = [{
            name        = "RACK1"
            description = "Rack Description"
            nodes = [{
              node_id = 201
              pod_id  = 2
            }]
          }]
        }]
      }]
    }]
  }]
}
