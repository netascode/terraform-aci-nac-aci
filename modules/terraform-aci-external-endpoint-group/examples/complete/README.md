<!-- BEGIN_TF_DOCS -->
# External Endpoint Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_external_endpoint_group" {
  source = "../.."

  tenant                      = "TF"
  l3out                       = "L3OUT1"
  name                        = "EXTEPG1"
  alias                       = "EXTEPG1-ALIAS"
  description                 = "My Description"
  preferred_group             = true
  qos_class                   = "level3"
  target_dscp                 = "CS0"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["IMPORTED-CON1"]
  route_control_profiles = [{
    name      = "RCP1"
    direction = "export"
  }]
  subnets = [
    {
      name                           = "SUBNET1"
      prefix                         = "10.1.1.0/24"
      description                    = "Subnet with BGP route summarization"
      import_route_control           = true
      export_route_control           = true
      shared_route_control           = true
      import_security                = true
      shared_security                = false
      aggregate_import_route_control = true
      aggregate_export_route_control = true
      aggregate_shared_route_control = true
      bgp_route_summarization        = true
      bgp_route_summarization_policy = "my-custom-bgp-policy"
      route_control_profiles = [{
        name      = "RCP1"
        direction = "import"
      }]
    },
    {
      name                            = "SUBNET2"
      prefix                          = "10.2.0.0/16"
      description                     = "Subnet with OSPF route summarization - custom policy"
      export_route_control            = true
      ospf_route_summarization        = true
      ospf_route_summarization_policy = "my-custom-ospf-policy"
    },
    {
      name                     = "SUBNET3"
      prefix                   = "10.3.0.0/16"
      description              = "Subnet with OSPF route summarization - default policy"
      export_route_control     = true
      ospf_route_summarization = true
      # ospf_route_summarization_policy not specified, will use default
    },
    {
      name                      = "SUBNET4"
      prefix                    = "10.4.0.0/16"
      description               = "Subnet with EIGRP route summarization"
      export_route_control      = true
      eigrp_route_summarization = true
    }
  ]
}
```
<!-- END_TF_DOCS -->