#!/bin/bash
################################################################################
# Modified from odoo_install.sh from Author: Yenthe Van Ginneken for 
# development machine
# Part 2 of 2 scripts
# This part installs odoo in a virtual environment
################################################################################

OE_HOME="/home/yoni/odoo-dev/17.0.enterprise"
OE_HOME_EXT="$OE_HOME/odoo"
OE_HOME_VENV="$OE_HOME/.venv"

OE_CONFIG="/$OE_HOME/odoo.conf"

# Set the default Odoo port (you still have to use -c /etc/odoo-server.conf for example to use this.)
OE_PORT="8069"
# Choose the Odoo version which you want to install. For example: 16.0, 15.0, 14.0 or saas-22. When using 'master' the master version will be installed.
# IMPORTANT! This script contains extra libraries that are specifically needed for Odoo 17.0
OE_VERSION="17.0"
# Set this to True if you want to install the Odoo enterprise version!
IS_ENTERPRISE="True"
# Set the superadmin password 
OE_SUPERADMIN="admin"

#--------------------------------------------------
# Install ODOO
#--------------------------------------------------
echo -e "\n==== Installing ODOO Server ===="
git clone --depth 1 --branch $OE_VERSION https://www.github.com/odoo/odoo $OE_HOME_EXT/

echo -e "\n---- Create venv  ----"
python3 -m venv $OE_HOME_VENV
echo -e "\n---- Activate venv ----"
# shellcheck disable=SC1091
source $OE_HOME_VENV/bin/activate
echo -e "\n---- Install python packages/requirements ----"
# shellcheck disable=SC1091
pip3 install -r $OE_HOME_EXT/requirements.txt
# shellcheck disable=SC1091
pip3 install python-codicefiscale phonenumbers

if [ $IS_ENTERPRISE = "True" ]; then
    # Odoo Enterprise install!
    pip3 install psycopg2-binary pdfminer.six
    echo -e "\n--- Create symlink for node"
    sudo ln -s /usr/bin/nodejs /usr/bin/node
    mkdir $OE_HOME/enterprise
    mkdir $OE_HOME/enterprise/addons

    GITHUB_RESPONSE=$(git clone --depth 1 --branch $OE_VERSION https://www.github.com/odoo/enterprise "$OE_HOME/enterprise/addons" 2>&1)
    while [[ $GITHUB_RESPONSE == *"Authentication"* ]]; do
        echo "------------------------WARNING------------------------------"
        echo "Your authentication with Github has failed! Please try again."
        printf "In order to clone and install the Odoo enterprise version you \nneed to be an offical Odoo partner and you need access to\nhttp://github.com/odoo/enterprise.\n"
        echo "TIP: Press ctrl+c to stop this script."
        echo "-------------------------------------------------------------"
        echo " "
        GITHUB_RESPONSE=$(git clone --depth 1 --branch $OE_VERSION https://www.github.com/odoo/enterprise "$OE_HOME/enterprise/addons" 2>&1)
    done

    echo -e "\n---- Added Enterprise code under $OE_HOME/enterprise/addons ----"
    echo -e "\n---- Installing Enterprise specific libraries ----"
    pip3 install num2words ofxparse dbfread ebaysdk firebase_admin pyOpenSSL
    sudo npm install -g less
    sudo npm install -g less-plugin-clean-css
fi
echo -e "\n---- Deactivate venv ----"
deactivate

echo -e "\n---- Create custom module directory ----"
mkdir $OE_HOME/custom
mkdir $OE_HOME/custom/addons


echo -e "* Create server config file"


touch ${OE_CONFIG}
echo -e "* Creating server config file"
printf '[options] \n; This is the password that allows database operations:\n' >> ${OE_CONFIG}
# shellcheck disable=SC2016
printf 'admin_passwd = %s\n' "${OE_SUPERADMIN}" >> ${OE_CONFIG}
# shellcheck disable=SC2072
if [ $OE_VERSION \> "11.0" ];then
    # shellcheck disable=SC2016
    printf 'http_port = %s\n' "${OE_PORT}" >> ${OE_CONFIG}
else
    # shellcheck disable=SC2016
    printf 'xmlrpc_port = %s\n'  "${OE_PORT}" >> ${OE_CONFIG}
fi
# shellcheck disable=SC2016
printf 'logfile = \n' >> ${OE_CONFIG}

if [ $IS_ENTERPRISE = "True" ]; then
    # shellcheck disable=SC2016
    printf 'addons_path=%s/enterprise/addons,%s/addons,%s/custom/addons\n' "${OE_HOME}" "${OE_HOME_EXT}" "${OE_HOME}" >> ${OE_CONFIG}
else
    # shellcheck disable=SC2016
    printf 'addons_path=%s/addons,%s/custom/addons\n' "${OE_HOME_EXT}" "${OE_HOME}">> ${OE_CONFIG}
fi


echo "-----------------------------------------------------------"
echo "Done!"
echo "Port: $OE_PORT"
echo "Configuraton file location: ${OE_CONFIG}"
echo "Code location: $OE_HOME"
echo "-----------------------------------------------------------"