# Inventory

The ```hosts.yaml``` file is the main inventory which defines the used hosts and groups. It only includes the APIC/MSO IP addresses everything else is defined in the respective ```host_vars``` and ```group_vars``` folders.

```yaml
---
aci:
  children:
    apic:
      hosts:
        apic1:
          apic_host: 10.51.77.64
          ansible_connection: local
    mso:
      hosts:
        mso1:
          mso_host: 10.51.77.229
          ansible_connection: local
```

## Host Variables

Host variables are defined in separate files under ```host_vars```. The [data model](../../data_model/overview/) (and the respective Yamale schema) defines the structure for the data input files.

## Group Variables

Global variables are typically defined in group_vars files, eg. ```group_vars/aci.yaml```. The following variables need to be defined:

Variable | Mandatory | Default | Description
---|---|---|---
**rendered_folder** | No | './rendered/..' | Defines the path to the root folder of rendered configurations and test cases, eg. ```{{ playbook_dir }}/rendered/{{ inventory_dir | basename }}/{{ inventory_hostname }}/```
**test_results_folder** | No | './test_results/..' | Defines the path to the root folder of test logs/reports, eg. ```{{ playbook_dir }}/test_results/{{ inventory_dir | basename }}/{{ inventory_hostname }}/```

### APIC

Variable | Mandatory | Default | Description
---|---|---|---
**apic_mode** | No | "only_provided" | - ```only_provided``` limits the list of objects to those configured as per inventory <br> - ```only_changed``` limits the list of objects to those that have changed compared to previous snapshot of the inventory (```previous_inventory``` is thr path to previous inventory files) <br> - ```all``` unconditionally includes all objects
**apic_delete_mode** | No | "aac" | - ```aac```: only delete objects with `orchestrator:aac` annotation <br> - ```all```: potentially delete all objects including objects not configured by AAC
**apic_username** | Yes | | The username for a local user created as part of the ```apic_bootstrap``` role and subsequently used by ```apic_deploy``` roles
**apic_password** | No | | The password used for ```apic_username``` user. This option is mutual exclusive with ```apic_private_key``` which is the preferred option.
**apic_private_key** | No | | The private key used for signature based authentication
**apic_public_cert** | No | | The certificate used for signature based authnetication
**apic_test_username** | No | | The username for a local user created as part of the ```apic_bootstrap``` role and used by ```test_apic_deploy``` role. If not defined ```apic_username``` is used instead.
**apic_test_password** | No | | The password used for ```apic_test_username``` user.  If not defined ```apic_password``` is used instead.
**apic_mso_username** | No | | The username for a local user created as part of the ```apic_bootstrap``` role and used by ```mso_deploy``` roles to configure ACI.
**apic_mso_password** | No | | The password used for ```apic_mso_username``` user
**apic_admin_password** | No | | Is used to update the 'admin' user password after running ```apic_bootstrap``` role
**apic_use_proxy** | No | No | If yes, uses a proxy defined as environment variable (see [aci_rest](https://docs.ansible.com/ansible/latest/collections/cisco/aci/aci_rest_module.html) Ansible module)
**apic_validate_certs** | No | No | If yes, validates the certificate presented by APIC (see [aci_rest](https://docs.ansible.com/ansible/latest/collections/cisco/aci/aci_rest_module.html) Ansible module)
**apic_option_render** | No | Yes | Enable or disable the render stage
**apic_option_configure** | No | Yes | Enable or disable the configure stage
**apic_option_delete** | No | No | Enable or disable the delete stage

### MSO

Variable | Mandatory | Default | Description
---|---|---|---
**mso_mode** | No | "only_provided" | - ```only_provided``` limits the list of objects to those configured as per inventory <br> - ```only_changed``` limits the list of objects to those that have changed compared to previous snapshot of the inventory (```previous_inventory``` is thr path to previous inventory files) <br> - ```all``` unconditionally includes all objects
**mso_platform** | No | "nd" | - ```standalone``` refers to a standalone MSO installation <br> - ```nd``` refers to a Nexus Dashboard installation
**mso_username** | Yes | | The username for a local user created as part of the ```mso_bootstrap``` role and subsequently used by ```mso_deploy``` roles
**mso_password** | Yes | | The password used for ```mso_username``` user
**mso_login_domain** | No | local | The login domain used for ```mso_username``` user
**mso_test_username** | No | | The username for a local user created as part of the ```mso_bootstrap``` role and used by ```test_mso_deploy``` roles. If not defined ```mso_username``` is used instead.
**mso_test_password** | No | | The password used for ```mso_test_username``` user. If not defined ```mso_password``` is used instead.
**mso_test_login_domain** | No | local | The login domain used for ```mso_test_username``` user
**mso_validate_certs** | No | No | If yes, validates the certificate presented by MSO
**mso_option_render** | No | Yes | Enable or disable the render stage
**mso_option_configure** | No | Yes | Enable or disable the configure stage
**mso_option_delete** | No | No | Enable or disable the delete stage
**mso_option_deploy** | No | Yes | If True all templates will be deployed to configured sites

### NAE

Variable | Mandatory | Default | Description
---|---|---|---
**nae_host** | Yes | | The hostname or IP of Network Assurance Engine (NAE)
**nae_port** | No | 443 | The port used to connect to NAE
**nae_username** | Yes | | The username for a local user
**nae_password** | Yes | | The password used for ```nae_username``` user
**nae_ignore_smart_events** | No | ["APP_EPG_NOT_DEPLOYED", "APP_EPG_HAS_NO_CONTRACT_IN_ENFORCED_VRF"] | List of Smart Event Mnomonics that should be ignored
