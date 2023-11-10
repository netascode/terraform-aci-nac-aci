terraform {
  required_version = ">= 1.0.0"

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

  name          = "RL1"
  description   = "My Description"
  hostname_ip   = "1.1.1.1"
  auth_type     = "password"
  protocol      = "ftp"
  path          = "/"
  port          = 21
  username      = "user1"
  password      = "password"
  mgmt_epg_type = "oob"
  mgmt_epg_name = "OOB1"
}

data "aci_rest_managed" "fileRemotePath" {
  dn = "uni/fabric/path-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fileRemotePath" {
  component = "fileRemotePath"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.fileRemotePath.content.name
    want        = module.main.name
  }

  equal "host" {
    description = "host"
    got         = data.aci_rest_managed.fileRemotePath.content.host
    want        = "1.1.1.1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.fileRemotePath.content.descr
    want        = "My Description"
  }

  equal "authType" {
    description = "authType"
    got         = data.aci_rest_managed.fileRemotePath.content.authType
    want        = "usePassword"
  }

  equal "protocol" {
    description = "protocol"
    got         = data.aci_rest_managed.fileRemotePath.content.protocol
    want        = "ftp"
  }

  equal "remotePath" {
    description = "remotePath"
    got         = data.aci_rest_managed.fileRemotePath.content.remotePath
    want        = "/"
  }

  equal "remotePort" {
    description = "remotePort"
    got         = data.aci_rest_managed.fileRemotePath.content.remotePort
    want        = "21"
  }

  equal "userName" {
    description = "userName"
    got         = data.aci_rest_managed.fileRemotePath.content.userName
    want        = "user1"
  }
}

data "aci_rest_managed" "fileRsARemoteHostToEpg" {
  dn = "${data.aci_rest_managed.fileRemotePath.id}/rsARemoteHostToEpg"

  depends_on = [module.main]
}

resource "test_assertions" "fileRsARemoteHostToEpg" {
  component = "fileRsARemoteHostToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.fileRsARemoteHostToEpg.content.tDn
    want        = "uni/tn-mgmt/mgmtp-default/oob-OOB1"
  }
}
