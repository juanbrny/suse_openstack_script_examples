#!/bin/bash

source login_rc.sh

if [ "$OS_LOGIN_FAILED" -eq "0" ]; then

  source test_data.sh

  #Create a project
  openstack project create $DEMO_PROJECT_NAME

  echo "Created project "$DEMO_PROJECT_NAME

  # Create admin users
  USER=$DEMO_PROJECT_NAME"admin"
  openstack user create \
      --project $DEMO_PROJECT_NAME \
      --password $DEMO_DEFAULT_USR_PWD \
      --email ${USER}"@"$DEMO_PROJECT_NAME".com" \
      ${USER}
  openstack role add \
      --project $DEMO_PROJECT_NAME \
      --user ${USER} \
      admin
  echo "Created admin user "$USER

  # Create standard users
  for (( i=1; i<=$DEMO_NUMUSERS; i++ ));
    do
      USER=$DEMO_PROJECT_NAME"user"$i
      openstack user create \
          --project $DEMO_PROJECT_NAME \
          --password $DEMO_DEFAULT_USR_PWD \
          --email ${USER}"@"$DEMO_PROJECT_NAME".com" \
          ${USER}
      openstack role add \
          --project $DEMO_PROJECT_NAME \
          --user ${USER} \
          Member
      echo "Created standard user "$USER
  done

  IMAGE_NAME=$DEMO_PROJECT_NAME"_test_image"

  openstack image create \
    --disk-format qcow2 \
    --container-format bare \
    --property os_type=linux \
    --file $DEMO_IMAGE \
    --private \
    --project $DEMO_PROJECT_NAME \
    --project-domain $DEMO_DOMAIN_NAME \
    $IMAGE_NAME
  echo "Created image "$IMAGE_NAME

  FLAVOR_NAME=$DEMO_PROJECT_NAME"_standard_size"
  openstack flavor create \
        --id $FLAVOR_NAME \
        --ram 1024 \
        --disk 5 \
        --ephemeral 0 \
        --vcpus 2 \
        --private \
        --project $DEMO_PROJECT_NAME \
        --project-domain $DEMO_DOMAIN_NAME \
        $FLAVOR_NAME

  echo "Created flavor "$FLAVOR_NAME

  # Now we login as the new admin to create the vm on the new project


  unset OS_PROJECT_NAME
  unset OS_PROJECT_ID
  unset OS_USERNAME
  unset OS_PASSWORD

  export OS_PASSWORD=$DEMO_DEFAULT_USR_PWD
  export OS_USERNAME=$DEMO_PROJECT_NAME"admin"
  export OS_PROJECT_NAME=$DEMO_PROJECT_NAME

  openstack token issue

  SERVER_NAME=$DEMO_PROJECT_NAME"_test_vm"
  #Get project security group
  ID_SEC_GROUP="$(openstack security group list --project dmlrdemo  -c ID -f value)"
  openstack server create \
    --flavor $FLAVOR_NAME \
    --image $IMAGE_NAME \
    --network fixed \
    --security-group $ID_SEC_GROUP \
    $SERVER_NAME
  echo "Created vm "$SERVER_NAME

  # Destroy current vars
  source logout_rc.sh
fi
