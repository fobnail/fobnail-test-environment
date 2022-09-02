# fobnail-test-environment

## Virtualenv initialization

```bash
git clone git@github.com:fobnail/fobnail-test-environment.git
cd fobnail-test-environment
virtualenv -p $(which python3) robot-venv
source robot-venv/bin/activate
pip install -U -r requirements.txt
```

## Usage example

```bash
robot -L TRACE -l token_provisioning.html tests/token_provision.robot
```
