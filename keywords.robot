*** Keywords ***

Open Server
    [Documentation]    Connect with device to run and build server on it.
    Run    cd ${absolute_fobnail_path} && mkdir .temp
    Run    cp provisioning/fobnail_test_root.crt ${absolute_fobnail_path}/.temp
    Run    cp provisioning/export.sh ${absolute_fobnail_path}
    # ${output}=    Run process    ./build.sh    env:FOBNAIL_PO_ROOT=.temp/fobnail_test_root.crt    env:FOBNAIL_LOG=debug    cwd=${absolute_fobnail_path}    shell=True
    # Should Be Equal As Integers    ${output.rc}    0
    ${output}=    Run    cd ${absolute_fobnail_path} && chmod +x export.sh && ./export.sh
    Should Contain    ${output}    Finished
    Start Process    ./export.sh --run    cwd=${absolute_fobnail_path}    shell=True    stdout=stdout.txt    stderr=stderr.txt
    Sleep    15s

Remove Transferred Files
    [Documentation]    Deleting transferred files from Fobnail repository.
    Run    cd ${absolute_fobnail_path}/.temp && rm fobnail_test_root.crt
    Run    cd ${absolute_fobnail_path} && rm export.sh

Generate Certificates
    [Documentation]    Generates certificates.
    Run    openssl req -inform der -in provisioning/tmp/fobnail.csr > provisioning/tmp/fobnail.pem
    Run    openssl x509 -req -in provisioning/tmp/fobnail.pem -days 3600 -CA provisioning/ca2.crt -CAkey provisioning/ca2.priv -CAcreateserial -extfile provisioning/leaf.ext -outform der -out provisioning/tmp/fobnail.crt
