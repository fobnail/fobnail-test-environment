# fobnail-test-environment

## Usage example

1. Download and prepare the testing repository by opening the terminal and
    running the following commands:

    ```bash
    git clone git@github.com:fobnail/fobnail-test-environment.git
    cd fobnail-test-environment
    virtualenv -p $(which python3) robot-venv
    source robot-venv/bin/activate
    pip install -U -r requirements.txt
    ```

1. Set the appropriate variables according to your configuration in the
    `variables.robot` file:
    
    ```bash
    ${server_device_ip}                    192.168.192.168
    ${server_device_username}              user
    ${server_device_password}              password
    ${fobnail_path}                        /home/user/fobnail
    ```

1. Running test cases example:

    ```bash
    robot -L TRACE -l <output_file_name>.html tests/<test_file_name>.robot
    ```
