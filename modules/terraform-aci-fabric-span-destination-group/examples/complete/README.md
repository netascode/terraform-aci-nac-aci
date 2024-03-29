<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric SPAN Destination Group Module Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_span_destination_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-span-destination-group"
  version = ">= 0.8.0"

  name                = "DST_GRP"
  description         = "My Fabric SPAN Destination Group"
  tenant              = "ABC"
  application_profile = "AP1"
  endpoint_group      = "EPG1"
  ip                  = "1.1.1.1"
  source_prefix       = "1.2.3.4/32"
  dscp                = "CS4"
  flow_id             = 10
  mtu                 = 9000
  ttl                 = 10
  span_version        = 2
  enforce_version     = true
}
```
<!-- END_TF_DOCS -->