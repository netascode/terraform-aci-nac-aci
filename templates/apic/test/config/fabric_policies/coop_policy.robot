*** Settings ***
Documentation   Verify ACI COOP Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify ACI COOP Policy
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/pol-default.json
    Should Be Equal Value Json String   ${r.json()}    $..coopPol.attributes.type   {{ apic.fabric_policies.coop_group_policy | default(defaults.apic.fabric_policies.coop_group_policy) }}
    