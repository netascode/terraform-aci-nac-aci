<!-- BEGIN_TF_DOCS -->
# Smart Licensing Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_smart_licensing" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-smart-licensing"
  version = ">= 0.8.0"

  mode               = "proxy"
  registration_token = "ABCDEFG"
  proxy_hostname_ip  = "a.proxy.com"
  proxy_port         = "80"
}
```
<!-- END_TF_DOCS -->