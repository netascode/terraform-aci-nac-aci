<!-- BEGIN_TF_DOCS -->
# Fabric Spine Switch Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_spine_switch_profile" {
  source  = "netascode/fabric-spine-switch-profile/aci"
  version = ">= 0.2.0"

  name               = "SPINE1001"
  interface_profiles = ["PROF1"]
  selectors = [{
    name         = "SEL1"
    policy_group = "POL1"
    node_blocks = [{
      name = "BLOCK1"
      from = 1001
      to   = 1001
    }]
  }]
}
```
<!-- END_TF_DOCS -->