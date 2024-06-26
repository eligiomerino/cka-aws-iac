#!/bin/bash

K8S_BACKEND_DIR="terraform"

start=$SECONDS

terraform -chdir=$K8S_BACKEND_DIR destroy -auto-approve

rm ansible/inventory

echo
echo -e "\nElapsed time = $SECONDS seconds."
echo
