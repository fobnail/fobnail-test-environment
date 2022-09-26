*** Keywords ***

Open Server
    [Documentation]    Connect with device to run and build server on it.
    Run    cd ${absolute_fobnail_path} && mkdir .temp
    Run    cp provisioning/fobnail_test_root.crt ${absolute_fobnail_path}/.temp
    ${output}=    Run process    ./build.sh    env:CI=true    env:FOBNAIL_PO_ROOT=.temp/fobnail_test_root.crt    env:FOBNAIL_LOG=debug    cwd=${absolute_fobnail_path}    shell=True
    Should Be Equal As Integers    ${output.rc}    0
    Start process    ./build.sh --run    env:CI=true    env:FOBNAIL_PO_ROOT=.temp/fobnail_test_root.crt    env:FOBNAIL_LOG=debug    cwd=${absolute_fobnail_path}    shell=True

Restore Initial State Of Server
    [Documentation]    Deleting transferred files from Fobnail repository.
    Terminate All Processes
    Run    cd ${absolute_fobnail_path}/.temp && rm fobnail_test_root.crt
    Run    cd ${absolute_fobnail_path}/target && rm flash.bin

Generate Certificates
    [Documentation]    Generates certificates.
    # [Arguments]    ${recived_csr}
    # ${output}=    Run process    openssl req -inform der    stdin=${recived_csr}    stdout=provisioning/tmp/fobnail.pem    shell=True
    # Should Be Equal As Integers    ${output.rc}    0
    # ${output}=    Run process    openssl x509 -req -days 3600 -CA provisioning/ca2.crt -CAkey provisioning/ca2.priv -CAcreateserial -extfile provisioning/leaf.ext -outform der    stdin=provisioning/tmp/fobnail.pem    stdout=provisioning/tmp/fobnail.crt    shell=True
    # Should Be Equal As Integers    ${output.rc}    0
    Run    openssl req -inform der -in ${csr} > provisioning/tmp/fobnail.pem
    Run    openssl x509 -req -in provisioning/tmp/fobnail.pem -days 3600 -CA provisioning/ca2.crt -CAkey provisioning/ca2.priv -CAcreateserial -extfile provisioning/leaf.ext -outform der -out provisioning/tmp/fobnail.crt
