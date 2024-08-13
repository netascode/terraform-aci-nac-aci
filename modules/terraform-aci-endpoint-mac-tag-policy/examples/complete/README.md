<!-- BEGIN_TF_DOCS -->
# Ednpoint MAC Tag Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_endpoint_mac_tag_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-mac-tag-policy"
  version = ">= 0.8.0"

  tenant        = "TEN1"
  mac           = "AB:CD:EF:DC:BA"
  bridge_domain = "all"
  vrf           = "TEN1-VRF"
  tags = [{
    key   = "Environment"
    value = "PROD"
  }]
}
```
<!-- END_TF_DOCS -->