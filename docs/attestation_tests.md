# Attestation

Test plan - module attestation

## /attest

1. Singing metadata 
1. Input handling - metadata signed with `fobnail_ak.key`
1. Send a query - add an endpoint in the dictionary
1. Return payload contains PCR selection and nonce
1. Output handling with TPM2_Quote() - add function in python

## /attest/{id}

1. id = `PC_ID` - result of `/admin/provision`
1. Input handling - result of TPM2_Quote()
1. Send a query - add an endpoint in the dictionary
