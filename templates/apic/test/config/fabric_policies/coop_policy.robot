*** Settings ***
Documentation   Verify ACI COOP Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify ACI COOP Policy
    GET   "/api/mo/uni/fabric/pol-default.json"
    String   $..coopPol.attributes.type   {{ apic.fabric_policies.coop_group_policy | default(defaults.apic.fabric_policies.coop_group_policy) }}
    