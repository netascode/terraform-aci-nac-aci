<!-- BEGIN_TF_DOCS -->
# Access FEX Interface Selector Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_access_fex_interface_selector" {
  source  = "netascode/access-fex-interface-selector/aci"
  version = ">= 0.2.0"

  interface_profile = "FEX101"
  name              = "1-2"
  policy_group_type = "access"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
}
```
<!-- END_TF_DOCS -->