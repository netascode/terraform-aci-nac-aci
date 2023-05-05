# Migration

The introduction of the unified ACI Nexus-as-Code module (with ACI-as-Code v0.7.0) further simplifies the way that the inventory is passed to the different ACI modules.

The 6 below modules have been consolidated in a single module:

- Access Policies (nac-access-policies)
- Fabric Policies (nac-fabric-policies)
- Pod Policies (nac-pod-policies)
- Node Policies (nac-node-policies)
- Interface Policies (nac-interface-policies)
- Tenant (nac-tenant)

This means that instead of calling each module individually, a single module ([nac-aci](https://registry.terraform.io/modules/netascode/nac-aci/aci)) can be called. This simplifies the Terraform plan, allows for easier state distribution and release management.

```
module "aci" {
  source  = "netascode/nac-aci/aci"
  version = "0.7.0"

  yaml_directories = ["data"]

  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = true
  manage_interface_policies = true
  manage_tenants            = true
}
```

## Steps

It is encouraged to migrate to the new unified module. Any new feature development will be done against this module. The migration steps are shown below:

1. Start by confirming that you have applied the latest configuration by either running `terraform apply` or `terraform plan`.
2. Update the `main.tf` to include the new module, and remove any references to any old modules. An example can be found here: [main.tf](https://wwwin-github.cisco.com/netascode/terraform-aac/blob/master/main.tf)
3. Update `yaml_directories` to include any folders that contain `*.yaml` inventory files.
4. Delete the `terraform.tfstate` file.
5. Run `terraform init --upgrade` to download the new module.
6. Run `terraform apply` to re-apply the existing configuration, in order to create a new state file.

!!! note

    This will not affect any resources that have been deployed previously.
