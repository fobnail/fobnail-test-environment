*** Settings ***
Library     SSHLibrary    timeout=90 seconds
Library     Process
Library     OperatingSystem
Library     String
Library     RequestsLibrary
Library     Collections

Suite Setup       Run Keyword    Open Server

Resource    ../variables.robot
Resource    ../keywords.robot

*** Test Cases ***

TOP001.001 Token provisioning
    [Documentation]    Checks that API command admin/token_provision works
    ...                correctly.
    Run    python3 provisioning/cc_cbor.py provisioning/chain.pem provisioning/tmp/fobnail.cbor
    Run    coap-client -t application/cbor -m post -f provisioning/tmp/fobnail.cbor coap://169.254.0.1/api/v1/admin/token_provision > provisioning/tmp/fobnail.csr
    SSHLibrary.Read Until    Certificate chain loaded
    SSHLibrary.Read Until    Generating new

TOP002.001 Provisioning complete
    [Documentation]    Checks that API command admin/token_provision works
    ...                correctly.
    Generate Certificates
    Run    coap-client -m post -f provisioning/tmp/fobnail.crt coap://169.254.0.1/api/v1/admin/provision_complete
    SSHLibrary.Read Until    Token provisioning complete
