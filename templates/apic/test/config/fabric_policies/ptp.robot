*** Settings ***
Documentation   Verify PTP
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify PTP
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/ptpmode.json
    Should Be Equal Value Json String   ${r.json()}    $..latencyPtpMode.attributes.state   {{ apic.fabric_policies.ptp_admin_state | default(defaults.apic.fabric_policies.ptp_admin_state) | cisco.aac.aac_bool("enabled") }}
