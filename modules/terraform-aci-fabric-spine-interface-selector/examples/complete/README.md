<!-- BEGIN_TF_DOCS -->
# Fabric Spine Interface Selector Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_spine_interface_selector" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-spine-interface-selector"
  version = ">= 1.0.1"

  interface_profile = "SPINE101"
  name              = "1-2"
  policy_group      = "FAB1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
  sub_port_blocks = [{
    name          = "SPB1"
    description   = "My Description"
    from_port     = 1
    from_sub_port = 1
    to_sub_port   = 2
  }]
}
```
<!-- END_TF_DOCS -->