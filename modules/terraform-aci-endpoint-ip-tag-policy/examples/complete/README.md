<!-- BEGIN_TF_DOCS -->
# Endpoint IP Tag Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_endpoint_ip_tag_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-ip-tag-policy"
  version = "> 0.9.3"

  ip     = "1.1.1.1"
  tenant = "TEN1"
  vrf    = "TEN1-VRF"
  tags = [{
    key   = "Environment"
    value = "PROD"
  }]
}
```
<!-- END_TF_DOCS -->