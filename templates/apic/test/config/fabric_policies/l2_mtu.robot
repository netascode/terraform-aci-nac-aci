*** Settings ***
Documentation   L2 MTU
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify L2 MTU
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/l2pol-default.json
    Should Be Equal Value Json String   ${r.json()}    $..l2InstPol.attributes.fabricMtu   {{ apic.fabric_policies.l2_port_mtu | default(defaults.apic.fabric_policies.l2_port_mtu) }}
