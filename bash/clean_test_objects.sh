#!/usr/bin/env bash

source login_rc.sh

if [ "$OS_LOGIN_FAILED" -eq "0" ]; then

  # Load demo vars
  source test_data.sh
#openstack project show -f json  dmlrdemo  | python -c "import sys, json; print json.load(sys.stdin)['id']"
  # Delete VM
  # First calculate project id
  PROJECT_ID=$(openstack project show -f json $DEMO_PROJECT_NAME  | python -c "import sys, json; print json.load(sys.stdin)['id']" 2> /dev/null)

  if [ $? -eq 0 ]; then

    SERVER_NAME=$DEMO_PROJECT_NAME"_test_vm"
    # Then get VM id (name is not enough for delete)
    SERVER_ID=$(openstack server list --project $PROJECT_ID  --name $SERVER_NAME -c ID -f value)

    echo "Delete server $SERVER_NAME / $SERVER_ID"
    openstack server delete $SERVER_ID
  else
    echo "Delete server $SERVER_NAME / $SERVER_ID failed"
  fi


  # Delete flavor
  FLAVOR_NAME=$DEMO_PROJECT_NAME"_standard_size"
  echo "Delete flavor $FLAVOR_NAME"
  openstack flavor delete $FLAVOR_NAME

  # Delete Image
  echo "Delete image "$DEMO_PROJECT_NAME"_test_image"
  openstack image delete \
    $DEMO_PROJECT_NAME"_test_image"

  #Delete users
  for (( i=1; i<=$DEMO_NUMUSERS; i++ ));
  do
      USER=$DEMO_PROJECT_NAME"user"$i
      echo "Delete user "$USER
      openstack user delete $USER
  done

  USER=$DEMO_PROJECT_NAME"admin"
  echo "Delete user "$USER
  openstack user delete $USER



  # Delete project
  echo "Delete project "$DEMO_PROJECT_NAME
  openstack project delete $DEMO_PROJECT_NAME

fi

source logout_rc.sh
