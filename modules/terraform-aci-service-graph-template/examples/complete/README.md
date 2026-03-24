<!-- BEGIN_TF_DOCS -->
# Service Graph Template Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
# Legacy single-device mode example
module "aci_service_graph_template" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-service-graph-template"
  version = ">= 0.8.0"

  tenant                  = "ABC"
  name                    = "SGT1"
  alias                   = "SGT1-ALIAS"
  description             = "My Description"
  template_type           = "FW_ROUTED"
  redirect                = true
  share_encapsulation     = true
  device_name             = "DEV1"
  device_tenant           = "DEF"
  device_function         = "GoThrough"
  device_copy             = false
  device_managed          = false
  device_adjacency_type   = "L2"
  consumer_direct_connect = false
  provider_direct_connect = true
}

# Multi-device mode example with explicit devices and connections
module "aci_service_graph_template_multi" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-service-graph-template"
  version = ">= 0.8.0"

  tenant              = "ABC"
  name                = "SGT_MULTI"
  description         = "Multi-device service graph template"
  template_type       = "FW_ROUTED"
  redirect            = true
  share_encapsulation = false

  devices = [
    {
      name          = "FW1"
      node_name     = "FIREWALL"
      template_type = "FW_ROUTED"
      function      = "GoTo"
      copy_device   = false
      managed       = false
    },
    {
      name        = "LB1"
      node_name   = "LOADBALANCER"
      tenant      = "DEF"
      copy_device = false
      managed     = false
    },
    {
      name        = "TAP1"
      node_name   = "COPY_DEVICE"
      copy_device = true
      managed     = false
    }
  ]

  connections = [
    {
      consumer_node  = "EPG-Consumer"
      provider_node  = "FW1"
      copy_node      = "TAP1"
      adjacency_type = "L3"
      unicast_route  = true
      direct_connect = false
    },
    {
      consumer_node  = "FW1"
      provider_node  = "LB1"
      adjacency_type = "L2"
      unicast_route  = false
      direct_connect = false
    },
    {
      consumer_node  = "LB1"
      provider_node  = "EPG-Provider"
      adjacency_type = "L3"
      unicast_route  = true
      direct_connect = true
    }
  ]
}
```
<!-- END_TF_DOCS -->