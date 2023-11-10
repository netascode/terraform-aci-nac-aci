<!-- BEGIN_TF_DOCS -->
# Access Spine Switch Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_spine_switch_profile" {
  source  = "netascode/access-spine-switch-profile/aci"
  version = ">= 0.2.1"

  name               = "SPINE1001"
  interface_profiles = ["SPINE1001"]
  selectors = [{
    name         = "SEL1"
    policy_group = "IPG1"
    node_blocks = [{
      name = "BLOCK1"
      from = 1001
      to   = 1001
    }]
  }]
}
```
<!-- END_TF_DOCS -->