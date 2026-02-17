<!-- BEGIN_TF_DOCS -->
# ACI Remote VXLAN Fabric Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_remote_vxlan_fabric_policy" {
  source = "./modules/terraform-aci-remote-vxlan-fabric-policy"

  tenant      = "infra"
  name        = "REMOTE_VXLAN_POLICY"
  border_gateway_set = "BGW1"
  remote_evpn_peers = [
    {
      ip                        = "10.1.1.1"
      description               = "Remote EVPN Peer 1"
      remote_as                 = "65001"
      admin_state               = true
      allow_self_as             = false
      disable_peer_as_check     = false
      password                  = "secret123"
      ttl                       = 10
      peer_prefix_policy        = "PREFIX_POLICY1"
      as_propagate              = "none"
      local_as                  = 65000
    }
  ]
}
```
<!-- END_TF_DOCS -->