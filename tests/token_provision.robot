*** Settings ***
Library     Process
Library     OperatingSystem
Library     String
Library     RequestsLibrary
Library     Collections

Suite Setup       Run Keyword    Open Server
Suite Teardown    Run Keyword    Remove Transferred Files

Resource    ../variables.robot
Resource    ../keywords.robot

*** Test Cases ***

TOP001.001 Token provisioning
    [Documentation]    Checks that API command admin/token_provision works
    ...                correctly.
    [Teardown]    Run Keyword If Test Failed    Set Suite Variable    ${prev_test_status}    FAIL
    Run    python3 provisioning/cc_cbor.py provisioning/chain.pem provisioning/tmp/fobnail.cbor
    ${output}=    Run    coap-client -v 9 -t application/cbor -m post -f provisioning/tmp/fobnail.cbor coap://${fobnail_ip}/api/v1/admin/token_provision -o provisioning/tmp/fobnail.csr
    Should Contain    ${output}    process incoming 2.01 response

TOP002.001 Provisioning complete
    [Documentation]    Checks that API command admin/token_provision works
    ...                correctly.
    IF   '${prev_test_status}'=='FAIL'    FAIL    Provisioning failed
    Generate Certificates
    ${output}=    Run    coap-client -v 9 -m post -f provisioning/tmp/fobnail.crt coap://${fobnail_ip}/api/v1/admin/provision_complete
    Should Contain    ${output}    process incoming 2.01 response
