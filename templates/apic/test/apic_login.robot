*** Settings ***
Documentation   APIC Login
Library         REST   https://%{APIC_TEST_HOSTNAME_IP}   ssl_verify=no
Library         OperatingSystem
Resource        ./apic_common.resource

*** Test Cases ***
Write Token
    Get APIC Token
    ${content}=    Set Variable   token = '${apic_token}'
    Create File   ${EXECDIR}/apic_token.py   ${content}

