<!-- BEGIN_TF_DOCS -->
# VLAN Pool Example
To run this example you need to execute:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `vlan_pool.yaml`

```hcl
apic:
  access_policies:
    vlan_pools:
      - name: VLAN_POOL_1
        ranges:
          - from: 1000
            to: 1099
```

#### `main.tf`

```hcl
module "vlan_pool" {
  source  = "netascode/nac-aci/aci"
  version = ">= 0.7.0"

  yaml_files = ["vlan_pool.yaml"]

  manage_access_policies = true
}
```
<!-- END_TF_DOCS -->