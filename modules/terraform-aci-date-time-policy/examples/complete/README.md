<!-- BEGIN_TF_DOCS -->
# Date Time Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_date_time_policy" {
  source  = "netascode/date-time-policy/aci"
  version = ">= 0.2.0"

  name                           = "DATE1"
  apic_ntp_server_master_stratum = 10
  ntp_admin_state                = false
  ntp_auth_state                 = true
  apic_ntp_server_master_mode    = true
  apic_ntp_server_state          = true
  ntp_servers = [{
    hostname_ip   = "100.1.1.1"
    preferred     = true
    mgmt_epg_type = "inb"
    mgmt_epg_name = "INB1"
    auth_key_id   = 1
  }]
  ntp_keys = [{
    id        = 1
    key       = "SECRETKEY"
    auth_type = "sha1"
    trusted   = true
  }]
}
```
<!-- END_TF_DOCS -->