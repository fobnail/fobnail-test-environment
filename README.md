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

1. Set the absolute Fobnail path on your device in the `variables.robot` file:
    
    ```bash
    ${absolute_fobnail_path}                        /home/user/fobnail
    ```

1. Running test cases example:

    ```bash
    robot -L TRACE -l <output_file_name>.html tests/<test_file_name>.robot
    ```
