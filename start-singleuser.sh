#!/bin/bash

set -eo pipefail

# credential management
if [[ -d "/opt/app-root/secrets/.aws" ]]; then
    # check that only one credential "type" is mounted
    NUM=$(find /opt/app-root/secrets/.aws/*/credentials | wc -l)
    mkdir -pv $HOME/.aws

    if [[ NUM -eq 1 ]]; then
        # symlink the credentials to default location
        ln -sf $(find /opt/app-root/secrets/.aws/*/credentials) $HOME/.aws/credentials
        ln -sf $(find /opt/app-root/secrets/.aws/*/config) $HOME/.aws/config
        ln -sf $(find /opt/app-root/secrets/.aws/*/s3_folder) $HOME/.aws/s3_folder
        # otherwise, do nothing
    fi
fi

# mkdir -pv /opt/app-root/.config/pip

# cat > /opt/app-root/.config/pip/pip.conf  <<EOL
# [global]
# index-url = https://nexus.corp.redhat.com/repository/pypi-python/simple
# cert = /etc/pki/tls/certs/ca-bundle.crt
# trusted-host = nexus.corp.redhat.com
#                pypi.org
# extra-index-url = https://pypi.org/simple
# EOL

mkdir -pv $HOME/.jupyter
cat > $HOME/.jupyter/jupyter_notebook_config.py  <<EOL
import os
from os.path import join, dirname, abspath
c.ServerProxy.servers = {
  'code-server': {
    'command': [
      'code-server',
        '--auth=none',
        '--disable-telemetry',
        '--bind-addr=localhost:{port}'
    ],
    'environment': {
      'PATH': "{home}/.local/bin:{path}".format(home=os.environ['HOME'], path=os.environ['PATH']),
      'SHELL': "/bin/bash"
    },
    'timeout': 20,
    'launcher_entry': {
      'title': 'VS Code',
      'icon_path': '/opt/app-root/share/icons/vscode.svg',
    }
  },
  'rclone': {
    'command': [
      'rclone',
      'rcd',
      '--rc-web-gui',
      '--rc-no-auth',
      '--rc-web-gui-no-open-browser',
      '--rc-user=admin',
      '--rc-pass=admin',
      '--rc-serve',
      '--cache-dir=/tmp',
      '--rc-addr=:{port}',
    ],
    'timeout': 20,
    'launcher_entry': {
      'title': 'RClone',
      'icon_path': '/opt/app-root/share/icons/rclone.svg',
    }
  }
}
EOL


## fix ssh permissions issues on startup
if [[ -d $HOME/.ssh ]]; then
  chmod 700 $HOME/.ssh
  chmod 644 $HOME/.ssh/*.pub && chmod 600 $HOME/.ssh/id_*
fi


# Execute the run script from the customised builder.
exec /opt/app-root/builder/run "$@"
