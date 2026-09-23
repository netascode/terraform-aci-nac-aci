<!-- BEGIN_TF_DOCS -->
# Managed Node Connectivity Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_managed_node_connectivity_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-managed-node-connectivity-group"
  version = "> 2.0.0"

  name                = "MGMT-CONN-GRP1"
  oob_mgmt_epg        = "OOB1"
  oob_ip_address_pool = "POOL1"
  inb_mgmt_epg        = "INB1"
  inb_ip_address_pool = "POOL2"
}
```
<!-- END_TF_DOCS -->