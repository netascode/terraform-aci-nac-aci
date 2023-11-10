locals {
  floors = flatten([
    for building in var.buildings : [
      for floor in coalesce(building.floors, []) : {
        key = "${building.name}/${floor.name}"
        value = {
          dn          = "uni/fabric/site-${var.name}/building-${building.name}/floor-${floor.name}"
          name        = floor.name
          description = floor.description
        }
      }
    ]
  ])
  rooms = flatten([
    for building in var.buildings : [
      for floor in coalesce(building.floors, []) : [
        for room in coalesce(floor.rooms, []) : {
          key = "${building.name}/${floor.name}/${room.name}"
          value = {
            dn          = "uni/fabric/site-${var.name}/building-${building.name}/floor-${floor.name}/room-${room.name}"
            name        = room.name
            description = room.description
          }
        }
      ]
    ]
  ])
  rows = flatten([
    for building in var.buildings : [
      for floor in coalesce(building.floors, []) : [
        for room in coalesce(floor.rooms, []) : [
          for row in coalesce(room.rows, []) : {
            key = "${building.name}/${floor.name}/${room.name}/${row.name}"
            value = {
              dn          = "uni/fabric/site-${var.name}/building-${building.name}/floor-${floor.name}/room-${room.name}/row-${row.name}"
              name        = row.name
              description = row.description
            }
          }
        ]
      ]
    ]
  ])
  racks = flatten([
    for building in var.buildings : [
      for floor in coalesce(building.floors, []) : [
        for room in coalesce(floor.rooms, []) : [
          for row in coalesce(room.rows, []) : [
            for rack in coalesce(row.racks, []) : {
              key = "${building.name}/${floor.name}/${room.name}/${row.name}/${rack.name}"
              value = {
                dn          = "uni/fabric/site-${var.name}/building-${building.name}/floor-${floor.name}/room-${room.name}/row-${row.name}/rack-${rack.name}"
                name        = rack.name
                description = rack.description
              }
            }
          ]
        ]
      ]
    ]
  ])
  nodes = flatten([
    for building in var.buildings : [
      for floor in coalesce(building.floors, []) : [
        for room in coalesce(floor.rooms, []) : [
          for row in coalesce(room.rows, []) : [
            for rack in coalesce(row.racks, []) : [
              for node in coalesce(rack.nodes, []) : {
                key = "${building.name}/${floor.name}/${room.name}/${row.name}/${rack.name}/${node.node_id}"
                value = {
                  dn  = "uni/fabric/site-${var.name}/building-${building.name}/floor-${floor.name}/room-${room.name}/row-${row.name}/rack-${rack.name}/rsnodeLocation-[topology/pod-${node.pod_id}/node-${node.node_id}]"
                  tDn = "topology/pod-${node.pod_id}/node-${node.node_id}"
                }
              }
            ]
          ]
        ]
      ]
    ]
  ])
}

resource "aci_rest_managed" "geoSite" {
  dn         = "uni/fabric/site-${var.name}"
  class_name = "geoSite"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "geoBuilding" {
  for_each   = { for building in var.buildings : building.name => building }
  dn         = "${aci_rest_managed.geoSite.dn}/building-${each.value.name}"
  class_name = "geoBuilding"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
}

resource "aci_rest_managed" "geoFloor" {
  for_each   = { for floor in local.floors : floor.key => floor.value }
  dn         = each.value.dn
  class_name = "geoFloor"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
  depends_on = [
    aci_rest_managed.geoBuilding
  ]
}

resource "aci_rest_managed" "geoRoom" {
  for_each   = { for room in local.rooms : room.key => room.value }
  dn         = each.value.dn
  class_name = "geoRoom"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
  depends_on = [
    aci_rest_managed.geoFloor
  ]
}

resource "aci_rest_managed" "geoRow" {
  for_each   = { for row in local.rows : row.key => row.value }
  dn         = each.value.dn
  class_name = "geoRow"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
  depends_on = [
    aci_rest_managed.geoRoom
  ]
}

resource "aci_rest_managed" "geoRack" {
  for_each   = { for rack in local.racks : rack.key => rack.value }
  dn         = each.value.dn
  class_name = "geoRack"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
  depends_on = [
    aci_rest_managed.geoRow
  ]
}

resource "aci_rest_managed" "geoRsNodeLocation" {
  for_each   = { for node in local.nodes : node.key => node.value }
  dn         = each.value.dn
  class_name = "geoRsNodeLocation"
  content = {
    tDn = each.value.tDn
  }
  depends_on = [
    aci_rest_managed.geoRack
  ]
}
