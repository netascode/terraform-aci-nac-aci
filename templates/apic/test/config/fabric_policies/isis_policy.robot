*** Settings ***
Documentation   Verify ISIS Policy
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify ISIS Policy
    GET   "/api/mo/uni/fabric/isisDomP-default.json"
    String   $..isisDomPol.attributes.redistribMetric   {{ apic.fabric_policies.fabric_isis_redistribute_metric | default(defaults.apic.fabric_policies.fabric_isis_redistribute_metric) }}
