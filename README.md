# [Odoo](https://www.odoo.com "Odoo's Homepage") Development Install Scripts

These scripts are based on the install script from Yenthe Van Ginneken ([Odoo Install Script](https://github.com/Yenthe666/InstallScript)).
The original script is splitted and modified to make room for installing Odoo in virtual environments for development.

The first script is to install machine wide requirements and the others are to install Odoo itself.

## Using The Scripts

### 1. Install Machine Wide Requirements
##### Download Requirement Installation Script
```
wget https://raw.githubusercontent.com/yonitjio/odoo-dev-install-scripts/main/odoo_install_req.sh
```
##### Make the script executable
```
chmod +x odoo_install_req.sh
```
##### Execute the script
```
sudo ./odoo_install_req.sh
```
### 2. Install Odoo in an virtual environment
#### Community edition
##### Download Odoo Installation Script
```
wget https://raw.githubusercontent.com/yonitjio/odoo-dev-install-scripts/main/odoo_install_dev_community.sh
```
##### Make the script executable
```
chmod +x odoo_install_dev_community.sh
```
##### Execute the script
```
./odoo_install_dev_community.sh
```
#### Enterprise edition
##### Download Odoo Installation Script
```
wget https://raw.githubusercontent.com/yonitjio/odoo-dev-install-scripts/main/odoo_install_dev_enterprise.sh
```
##### Make the script executable
```
chmod +x odoo_install_dev_enterprise.sh
```
##### Execute the script
```
./odoo_install_dev_enterprise.sh
```

## Parameters
Some of the original parameters are removed as they are not needed (my opinion).

You can modify them the same way the original scripts.

## What's Next
Up on successful installation, Odoo source code will be installed in current user home directory. E.g:
* Community edition
```
/home/<current_user>/odoo-dev/17.0.community
```
* Enterprise edition
```
/home/<current_user>/odoo-dev/17.0.enterprise
```

#### Tips for Beginner with VS Code
You can use the following as your `launch.json` file:
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
    {
      "name": "Odoo",
      "type": "debugpy",
      "request": "launch",
      "program": "${workspaceRoot}/odoo/odoo-bin",
      "args": ["-c", "${workspaceFolder}/odoo.conf"],
      "gevent": false,
      "envFile": "${workspaceFolder}/debug.env",
      "console": "integratedTerminal",
      "justMyCode": false,
      "python": "${workspaceRoot}/.venv/bin/python3"
    }
  ]
}
```

#### Tips for WSL2
1. Before running `odoo_install_req.sh`, edit the file and change line 9 from `OE_USER=$(logname)` to `OE_USER=${SUDO_USER:-${USER}}`.
2. The script may fail to create user for PostgreSQL, if this happens you need to create the user manually:
   1. Make sure the postgresql service is running:
      ```bash
      sudo service postgresql start
      ```
   2. Create new user
      ```bash
      sudo su - postgres -c "createuser -s <CHANGE_THIS_TO_YOUR_USER_NAME>" 2> /dev/null || true
      ```
3. If you're using VS Code, you will need to install [VS Code Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) or at the very least [VS Code WSL Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl).
4. Postgresql may not automatically starts, to start it manually run this on your terminal:
   ```bash
   sudo service postgresql start
   ```