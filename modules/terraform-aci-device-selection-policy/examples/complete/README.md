<!-- BEGIN_TF_DOCS -->
# Device Selection Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
# Legacy single-device mode example
module "aci_device_selection_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-device-selection-policy"
  version = ">= 0.8.0"

  tenant                                                  = "ABC"
  contract                                                = "CON1"
  service_graph_template                                  = "SGT1"
  sgt_device_name                                         = "DEV1"
  consumer_l3_destination                                 = true
  consumer_permit_logging                                 = true
  consumer_logical_interface                              = "INT1"
  consumer_redirect_policy                                = "REDIR1"
  consumer_bridge_domain                                  = "BD1"
  consumer_service_epg_policy                             = "SEPGP1"
  consumer_custom_qos_policy                              = "QOSP1"
  provider_l3_destination                                 = true
  provider_permit_logging                                 = true
  provider_logical_interface                              = "INT2"
  provider_external_endpoint_group                        = "EXTEPG1"
  provider_external_endpoint_group_l3out                  = "L3OUT1"
  provider_external_endpoint_group_redistribute_bgp       = true
  provider_external_endpoint_group_redistribute_ospf      = true
  provider_external_endpoint_group_redistribute_connected = true
  provider_external_endpoint_group_redistribute_static    = true
  provider_service_epg_policy                             = "SEPGP1"
  provider_custom_qos_policy                              = "QOSP1"
}

# Multi-device mode example
module "aci_device_selection_policy_multi" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-device-selection-policy"
  version = "> 1.2.0"

  tenant                 = "ABC"
  contract               = "CON2"
  service_graph_template = "SGT2"

  devices = [
    {
      name      = "FW1"
      tenant    = "COMMON"
      node_name = "FW1_NODE"
      consumer = {
        l3_destination    = true
        permit_logging    = false
        logical_interface = "CONSUMER_INT"
        redirect_policy = {
          name   = "REDIR_CONSUMER"
          tenant = "ABC"
        }
      }
      provider = {
        l3_destination    = true
        permit_logging    = false
        logical_interface = "PROVIDER_INT"
        redirect_policy = {
          name   = "REDIR_PROVIDER"
          tenant = "ABC"
        }
      }
    },
    {
      name      = "LB1"
      node_name = "LB1_NODE"
      consumer = {
        logical_interface = "LB_CONSUMER_INT"
        bridge_domain = {
          name   = "BD_CONSUMER"
          tenant = "ABC"
        }
      }
      provider = {
        logical_interface = "LB_PROVIDER_INT"
        external_endpoint_group = {
          tenant = "ABC"
          l3out  = "L3OUT1"
          name   = "EXTEPG1"
          redistribute = {
            bgp       = true
            connected = true
          }
        }
      }
    }
  ]
}
```
<!-- END_TF_DOCS -->