# Platform provisioning

Test plan - module platform provisioning

## /admin/provision/ek

1. Add `fobnail_ek.crt` to the test environment
1. Convert crt to cbor - add python function
1. Send a query - add an endpoint in the dictionary
1. Return `EK_ID` from `Location-Path` for the next tests

## /admin/provision/aik

1. Adding `fobnail_ak.key` to the test environment
1. Input handling - `fobnail_ak.key` +` EK_ID`
1. Send a query - add an endpoint in the dictionary
1. Return `AK_ID` from `Location-Path` and payload
1. Use payload to make an active credential - function in python if possible,
    if not some bash commands

## /admin/provision

1. Input handling - `AK_ID` +` EK_ID` + result of Credential Activation
1. Send a query - add an endpoint in the dictionary
1. Return `PC_ID` from `Location-Path`

## /admin/provision/{id}/meta

1. id = `PC_ID`
1. Singing metadata - function in python (useful also for other tests)
1. Input handling - metadata signed with `fobnail_ak.key` and convert to
    cbor - add python function
1. Send a query - add an endpoint in the dictionary
1. Add support for two correct response codes in TestModule.py (required also
    for other tests)

## /admin/provision/{id}/rim

1. id = `PC_ID`
1. Singing metadata
1. Input handling - hardcoded metadata signed with `fobnail_ak.key`
1. Send a query - add an endpoint in the dictionary

## /admin/provision/{id}

1. id = `PC_ID`
1. Send a query (no payload) - add an endpoint in the dictionary
