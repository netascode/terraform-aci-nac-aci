terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

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

data "aci_rest_managed" "geoSite" {
  dn = "uni/fabric/site-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "geoSite" {
  component = "geoSite"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.geoSite.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.geoSite.content.descr
    want        = "Site Description"
  }
}

data "aci_rest_managed" "geoBuilding" {
  dn = "${data.aci_rest_managed.geoSite.id}/building-BUILDING1"

  depends_on = [module.main]
}

resource "test_assertions" "geoBuilding" {
  component = "geoBuilding"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.geoBuilding.content.name
    want        = "BUILDING1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.geoBuilding.content.descr
    want        = "Building Description"
  }
}

data "aci_rest_managed" "geoFloor" {
  dn = "${data.aci_rest_managed.geoBuilding.id}/floor-FLOOR1"

  depends_on = [module.main]
}

resource "test_assertions" "geoFloor" {
  component = "geoFloor"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.geoFloor.content.name
    want        = "FLOOR1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.geoFloor.content.descr
    want        = "Floor Description"
  }
}

data "aci_rest_managed" "geoRoom" {
  dn = "${data.aci_rest_managed.geoFloor.id}/room-ROOM1"

  depends_on = [module.main]
}

resource "test_assertions" "geoRoom" {
  component = "geoRoom"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.geoRoom.content.name
    want        = "ROOM1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.geoRoom.content.descr
    want        = "Room Description"
  }
}

data "aci_rest_managed" "geoRow" {
  dn = "${data.aci_rest_managed.geoRoom.id}/row-ROW1"

  depends_on = [module.main]
}

resource "test_assertions" "geoRow" {
  component = "geoRow"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.geoRow.content.name
    want        = "ROW1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.geoRow.content.descr
    want        = "Row Description"
  }
}

data "aci_rest_managed" "geoRack" {
  dn = "${data.aci_rest_managed.geoRow.id}/rack-RACK1"

  depends_on = [module.main]
}

resource "test_assertions" "geoRack" {
  component = "geoRack"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.geoRack.content.name
    want        = "RACK1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.geoRack.content.descr
    want        = "Rack Description"
  }
}

data "aci_rest_managed" "geoRsNodeLocation" {
  dn = "${data.aci_rest_managed.geoRack.id}/rsnodeLocation-[topology/pod-2/node-201]"

  depends_on = [module.main]
}

resource "test_assertions" "geoRsNodeLocation" {
  component = "geoRsNodeLocation"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.geoRsNodeLocation.content.tDn
    want        = "topology/pod-2/node-201"
  }
}
