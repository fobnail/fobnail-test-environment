*** Settings ***
Library     Process
Library     OperatingSystem
Library     String
Library     RequestsLibrary
Library     Collections
Library     ../lib/TestModule.py

Suite Setup       Run Keyword    Open Server
Suite Teardown    Run Keyword    Restore Initial State Of Server

Resource    ../variables.robot
Resource    ../keywords.robot

*** Test Cases ***

TOP001.001 Token provisioning
    [Documentation]    Checks that API command admin/token_provision works
    ...                correctly.
    [Teardown]    Run Keyword If Test Failed    Set Suite Variable    ${prev_test_status}    FAIL
    ${cbor}=    Convert Pem To Cbor    ${pem}
    Send Data    ${ep_token_provision}    ${cbor}

TOP002.001 Provisioning complete
    [Documentation]    Checks that API command admin/token_provision works
    ...                correctly.
    IF   '${prev_test_status}'=='FAIL'    FAIL    Provisioning failed
    Generate Certificates
    Send Data    ${ep_provision_complete}    ${crt}
