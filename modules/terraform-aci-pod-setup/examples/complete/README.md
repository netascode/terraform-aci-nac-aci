<!-- BEGIN_TF_DOCS -->
# Pod Setup Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_pod_setup" {
  source  = "netascode/pod-setup/aci"
  version = ">= 0.1.1"

  pod_id   = 2
  tep_pool = "10.2.0.0/16"
  external_tep_pools = [
    {
      prefix                 = "172.16.18.0/24"
      reserved_address_count = 4
    },
    {
      prefix                 = "172.16.17.0/24"
      reserved_address_count = 2
    }
  ]
  remote_pools = [
    {
      id          = 1
      remote_pool = "10.191.200.0/24"
    },
    {
      id          = 2
      remote_pool = "10.191.202.0/24"
    }
  ]
}
```
<!-- END_TF_DOCS -->