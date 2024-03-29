<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric SPAN Source Group Module Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_span_source_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-span-source-group"
  version = ">= 0.8.0"

  name        = "SPAN1"
  description = "My Test Fabric Span Source Group"
  admin_state = false
  sources = [
    {
      name        = "SRC1"
      description = "Source1"
      direction   = "both"
      span_drop   = "no"
      tenant      = "TEN1"
      vrf         = "VRF1"
      fabric_paths = [
        {
          node_id = 1001
          port    = 1
        }
      ]
    },
    {
      name          = "SRC2"
      description   = "Source2"
      direction     = "in"
      span_drop     = "no"
      tenant        = "TEN1"
      bridge_domain = "BD1"
      fabric_paths = [
        {
          node_id = 101
          port    = 49
        },
      ]
    }
  ]
  destination_name        = "DESTINATION1"
  destination_description = "My Destination"
}
```
<!-- END_TF_DOCS -->