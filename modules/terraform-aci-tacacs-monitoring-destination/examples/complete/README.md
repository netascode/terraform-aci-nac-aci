<!-- BEGIN_TF_DOCS -->
# Example

```hcl
module "aci_tacacs_monitoring_destination" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tacacs-monitoring-destination"
  version = ">= 0.8.0"

  name        = "TACACS_MON1"
  description = "My Description"
  destinations = [{
    hostname_ip   = "1.1.1.1"
    port          = 49
    protocol      = "pap"
    key           = "cisco123"
    mgmt_epg_type = "oob"
    mgmt_epg_name = "OOB1"
    }, {
    hostname_ip   = "2.2.2.2"
    port          = 49
    protocol      = "chap"
    mgmt_epg_type = "inb"
    mgmt_epg_name = "INB1"
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.19.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aci_tacacs_monitoring_destination"></a> [aci\_tacacs\_monitoring\_destination](#module\_aci\_tacacs\_monitoring\_destination) | netascode/nac-aci/aci//modules/terraform-aci-tacacs-monitoring-destination | >= 0.8.0 |
<!-- END_TF_DOCS -->