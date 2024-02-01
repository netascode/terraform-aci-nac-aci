<!-- BEGIN_TF_DOCS -->
# Syslog Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_syslog_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-syslog-policy"
  version = ">= 0.8.0"

  name                = "SYSLOG1"
  description         = "My Description"
  format              = "nxos"
  show_millisecond    = true
  show_timezone       = true
  admin_state         = true
  local_admin_state   = false
  local_severity      = "errors"
  console_admin_state = false
  console_severity    = "critical"
  destinations = [{
    name          = "DEST1"
    hostname_ip   = "1.1.1.1"
    protocol      = "tcp"
    port          = 1514
    admin_state   = false
    format        = "nxos"
    facility      = "local1"
    severity      = "information"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
  }]
}
```
<!-- END_TF_DOCS -->