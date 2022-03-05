*** Settings ***
Documentation   Verify PTP
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify PTP
    GET   "/api/mo/uni/fabric/ptpmode.json"
    String   $..latencyPtpMode.attributes.state   {{ apic.fabric_policies.ptp_admin_state | default(defaults.apic.fabric_policies.ptp_admin_state) | cisco.aac.aac_bool("enabled") }}
