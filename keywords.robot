*** Keywords ***

Open Server
    [Documentation]    Connect with device to run and build server on it.
    SSHLibrary.Open Connection    ${server_device_ip}    prompt=~$
    SSHLibrary.Set Client Configuration    timeout=90s
    SSHLibrary.Login    ${server_device_username}    ${server_device_password}
    SSHLibrary.Write    cd ${fobnail_path}
    SSHLibrary.Write    export FOBNAIL_PO_ROOT=root.crt
    SSHLibrary.Write    export FOBNAIL_LOG=debug
    SSHLibrary.Write    ./build.sh --run
    SSHLibrary.Read Until    Hello from main

Generate Certificates
    [Documentation]    Generates certificates.
    Run    openssl req -inform der -in provisioning/tmp/fobnail.csr > provisioning/tmp/fobnail.pem
    Run    openssl x509 -req -in provisioning/tmp/fobnail.pem -days 3600 -CA provisioning/ca2.crt -CAkey provisioning/ca2.priv -CAcreateserial -extfile provisioning/leaf.ext -outform der -out provisioning/tmp/fobnail.crt
