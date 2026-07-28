<!-- BEGIN_TF_DOCS -->
# Proxy Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_proxy_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-proxy-policy"
  version = ">= 1.0.2"

  http_url       = "http://172.16.8.1:8080"
  http_username  = "user_http"
  http_password  = "Cisco!234"
  https_url      = "https://172.16.8.1:8443"
  https_username = "user_https"
  https_password = "Cisco!234"
  ignore_hosts = [
    "192.168.8.1",
    "hostname-1"
  ]
}
```
<!-- END_TF_DOCS -->