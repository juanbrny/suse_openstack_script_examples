#!/usr/bin/env bash
# To use an OpenStack cloud you need to authenticate against the Identity
# service named keystone, which returns a **Token** and **Service Catalog**.
# The catalog contains the endpoints for all services the user/tenant has
# access to - such as Compute, Image Service, Identity, Object Storage, Block
# Storage, and Networking (code-named nova, glance, keystone, swift,
# cinder, and neutron).
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color
# *NOTE*: Using the 3 *Identity API* does not necessarily mean any other
# OpenStack API is version 3. For example, your cloud provider may implement
# Image API v1.1, Block Storage API v2, and Compute API v2.0. OS_AUTH_URL is
# only for the Identity API served through keystone.
export OS_AUTH_URL=http://acme_public_keystone_endpoint:5000/v3/
# With the addition of Keystone we have standardized on the term **project**
# as the entity that owns the resources.
#export OS_PROJECT_ID=9a8c3e344d82477792982bb6e286f947
export OS_PROJECT_NAME="admin"
export OS_USER_DOMAIN_NAME="Default"
if [ -z "$OS_USER_DOMAIN_NAME" ]; then unset OS_USER_DOMAIN_NAME; fi
export OS_PROJECT_DOMAIN_ID="default"
if [ -z "$OS_PROJECT_DOMAIN_ID" ]; then unset OS_PROJECT_DOMAIN_ID; fi
# unset v2.0 items in case set
unset OS_TENANT_ID
unset OS_TENANT_NAME
# In addition to the owning entity (tenant), OpenStack stores the entity
# performing the action as the **user**.
export OS_USERNAME="acmeadmin"
# With Keystone you pass the keystone password.
echo "+-----------------------------------------------------------------"
echo "|"
echo -e "| ${GREEN}SUSE OpenStack Cloud (SOC)${NC}"
echo "| Password for project $OS_PROJECT_NAME as user $OS_USERNAME"

OS_PASSWORD_INPUT=$(systemd-ask-password "| Password:")

export OS_PASSWORD=$OS_PASSWORD_INPUT
# If your configuration has multiple regions, we set that information here.
# OS_REGION_NAME is optional and only valid in certain environments.
export OS_REGION_NAME="RegionOne"
# Don't leave a blank variable, unset it if it was empty
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3



if openstack token issue &> /dev/null
then
	echo -e "| SOC> ${GREEN}Authentication Successful!${NC}"
	echo "| SOC> User:"${OS_USERNAME}" Domain:"${OS_USER_DOMAIN_NAME}" Project:"${OS_PROJECT_NAME}""
  echo "| SOC> Run 'openstack help' for a list of available commands"
	export PS1="${PURPLE}\u${NC}@${RED}\h${NC}:${GREEN}[SOC>${OS_USERNAME}@${OS_USER_DOMAIN_NAME}/${OS_PROJECT_NAME}]${NC}:${PURPLE}\w${NC} # "
	export OS_LOGIN_FAILED=0
else
	echo -e "| SOC> ${RED}Authentication Failed!${NC}"
	export PS1="${PURPLE}\u${NC}@${RED}\h${NC}:${PURPLE}]\w${NC} # "
	export OS_LOGIN_FAILED=1
	unset OS_AUTH_URL
	unset OS_AUTH_VERSION
	unset OS_IDENTITY_API_VERSION
	unset OS_PROJECT_DOMAIN_NAME
	unset OS_USER_DOMAIN_NAME
	unset OS_DEFAULT_DOMAIN
	unset OS_REGION_NAME
	unset OS_PROJECT_NAME
	unset OS_PROJECT_ID
	unset OS_USERNAME
	unset OS_PASSWORD
fi
echo "|"
echo "+-----------------------------------------------------------------"
