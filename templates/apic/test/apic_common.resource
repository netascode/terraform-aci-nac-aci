*** Settings ***
Library   REST   https://%{APIC_TEST_HOSTNAME_IP}   ssl_verify=no

*** Variables ***
${login_json}   {"aaaUser" : {"attributes" : {"name" : "%{APIC_TEST_USERNAME}", "pwd" : "%{APIC_TEST_PASSWORD}"}}}

*** Keywords ***
Get APIC Token
    Wait Until Keyword Succeeds   2x   1 minute   POST   /api/aaaLogin.json   ${login_json}
    ${r_token}=   String   $..token
    Set Suite Variable   ${apic_token}   ${r_token[0]}

Login APIC
    ${apic_token}=   Get Variable Value   ${token}
    Run Keyword If   '${apic_token}' == 'None'   Get APIC Token
    Set Headers   {"Cookie": "APIC-cookie=${apic_token}"}