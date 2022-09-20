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

1. Running test cases example:

    ```bash
    robot -L TRACE -o <output-file-prefix> -r <report_file_prefix> -l <output_file_name>.html -v absolute_fobnail_path:<path_to_fobnail> tests/<test_file_name>.robot
    ```
