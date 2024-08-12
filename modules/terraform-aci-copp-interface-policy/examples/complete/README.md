<!-- BEGIN_TF_DOCS -->
# CoPP Interface Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_copp_interface_policy" {
  source = "./modules/terraform-aci-copp-interface-policy"

  name        = "COPP1"
  description = "COPP1 Description"
  protocol_policies = [{
    name            = "COPP-PROTO1"
    rate            = "123"
    burst           = "1234"
    match_protocols = ["bgp", "ospf"]
  }]
}
```
<!-- END_TF_DOCS -->