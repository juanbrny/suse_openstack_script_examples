# SUSE Openstack Cloud script examples
Examples about how to work with SUSE OpenStack Cloud using command line tools or the REST API

Methods: 
- Bash scripts with pyhton based command line tools
- REST API calls using curl
- Python scripts

## Demo data set

The scripts cover some of the typical OpenStack operation tasks and are meant to have an understanding how you can interact with the cloud without the Web UI.

All the scripts will do the same operations:

- Create a project
- Create a project admin
- Create a set of project users
- Create a new glance image for the project
- Create a new project level flavour
- Createa a vm based on the newly created flavour and image

A cleanup script is also available.

## Bash

Shows how to use the command line client to operate the cloud.

### Prerequisites


#### Install with rpm repos
Python based command line tools are available on the SUSE OpenStack Cloud repositories and the repos should be present on all the deployed cloud nodes.

If you need to deploy them from a normal SLES/openSUSE box you can use the openSUSE repos:

https://software.opensuse.org/package/python-openstackclient

Installation:

```
zypper in python-openstackclient
```

#### Install with Python pip

First install pip if not available yet:
```
zypper install python-devel python-pip
```

Then launch the pip installation:
```
pip install python-openstackclient
```


### Authentication

Before being able to use the openstack client tools you need to setup your authentication environment variables.

You can easily do it thanks to the preconfigured OpenStack RC files that you can download from the Horizon dashboard. The file can also be created from scratch filling the rigth values for all the parameters. 
The bash folder contains a OpenStack RC template file with handy features (login failure/error feedback, command prompt with user/domain/project info, ...) that you can use for your own environments.

You can find more info about how to create RC files:
https://www.suse.com/documentation/suse-openstack-cloud-8/singlehtml/suse-openstack-cloud-upstream-user/suse-openstack-cloud-upstream-user.html#id2680


> We'll be using Keystone API v3 on all scripts

### Login and logout

There are two rc files that must be sources to setup/destroy Keystone related authentication variables:

- source loginc_rc.sh 
- source logout_rc.sh

Make sure to set the rigth Keystone v3 enpoint url, domain name, project name and username on login_rc.sh.

### Test data

Customize the project name and number of users to be used to populate the test data on test_data.sh.

### Create test objects

The script create_test_objects.sh will take care of the creation of the objects described on the data set customized according to the values defined on the test data file above.

### Destroy test objects

Cleans all objects restoring the original state of the OpenStack environment.

## REST API

## Python

