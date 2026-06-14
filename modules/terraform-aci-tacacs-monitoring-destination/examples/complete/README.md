<!-- BEGIN_TF_DOCS -->
# Example

```hcl
module "aci_tacacs_monitoring_destination" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tacacs-monitoring-destination"
  version = ">= 0.8.0"

  name        = "TACACS_MON1"
  description = "My Description"
  destinations = [{
    name          = "DEST1"
    host          = "1.1.1.1"
    port          = 49
    auth_protocol = "pap"
    key           = "cisco123"
    description   = "Primary TACACS Destination"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
    }, {
    name              = "DEST2"
    host              = "2.2.2.2"
    port              = 49
    auth_protocol     = "chap"
    populate_cmd_args = true
    mgmt_epg_type     = "inb"
    mgmt_epg_name     = "INB1"
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aci_tacacs_monitoring_destination"></a> [aci\_tacacs\_monitoring\_destination](#module\_aci\_tacacs\_monitoring\_destination) | netascode/nac-aci/aci//modules/terraform-aci-tacacs-monitoring-destination | >= 0.8.0 |
<!-- END_TF_DOCS -->