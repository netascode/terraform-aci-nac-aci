*** Settings ***
Documentation   Verify APIC Connectivity Preference
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify APIC Connectivity Preference
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/connectivityPrefs.json
    Should Be Equal Value Json String   ${r.json()}    $..mgmtConnectivityPrefs.attributes.interfacePref   {{ apic.fabric_policies.apic_conn_pref | default(defaults.apic.fabric_policies.apic_conn_pref) }}
