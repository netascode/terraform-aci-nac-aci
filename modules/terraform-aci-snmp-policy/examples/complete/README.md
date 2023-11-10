<!-- BEGIN_TF_DOCS -->
# SNMP Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_snmp_policy" {
  source  = "netascode/snmp-policy/aci"
  version = ">= 0.2.0"

  name        = "SNMP1"
  admin_state = true
  location    = "LOC"
  contact     = "CON"
  communities = ["COM1"]
  users = [{
    name               = "USER1"
    privacy_type       = "aes-128"
    privacy_key        = "ABCDEFGH"
    authorization_type = "hmac-sha1-96"
    authorization_key  = "ABCDEFGH"
  }]
  trap_forwarders = [{
    ip   = "1.1.1.1"
    port = 1162
  }]
  clients = [{
    name          = "CLIENT1"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
    entries = [{
      ip   = "10.1.1.1"
      name = "NMS1"
    }]
  }]
}
```
<!-- END_TF_DOCS -->