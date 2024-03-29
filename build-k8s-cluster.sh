#!/bin/bash

SSH_KEY_FILE=".ssh/ec2-key"
USER_NAME="sysadmin"
K8S_BACKEND_DIR="terraform"

start=$SECONDS

terraform -chdir=$K8S_BACKEND_DIR init

if [ "$?" -eq 0 ]; then
    terraform -chdir=$K8S_BACKEND_DIR apply -auto-approve
else
    echo "[Error] Could not start Terraform building."
    exit 99
fi

if [ "$?" -eq 0 ]; then
    CONTROL_PLANE_IPS=$(terraform -chdir=$K8S_BACKEND_DIR output -json control_plane_data | jq -r '.[] .public_ip')
    WORKER_NODE_IPS=$(terraform -chdir=$K8S_BACKEND_DIR output -json worker_node_data | jq -r '.[] .public_ip')
    ANSIBLE_PORT="7022"

    export ANSIBLE_CONFIG=ansible/ansible.cfg

    # truncates the inventory file to zero length
    : > ansible/inventory
    
    # writes new content to the inventory file
    echo "[control_plane]" > ansible/inventory
    while IFS= read -r ip
    do
        echo "$ip:$ANSIBLE_PORT" >> ansible/inventory
    done < <(printf '%s\n' "$CONTROL_PLANE_IPS")

    echo "[worker_node]" >> ansible/inventory
    while IFS= read -r ip
    do
        echo "$ip:$ANSIBLE_PORT" >> ansible/inventory
    done < <(printf '%s\n' "$WORKER_NODE_IPS")

    echo "Giving up to 3 minutes for the compute instances to become available..." 
    sleep 180

    echo "Ping checking..."
    ansible all --private-key $SSH_KEY_FILE -i ansible/inventory -u $USER_NAME -m ping

    if [ "$?" -eq 0 ]; then
        echo "Setting up K8s cluster..."
        ansible-playbook ansible/playbook-install.yaml --private-key $SSH_KEY_FILE -i ansible/inventory -u $USER_NAME
    else
        echo "[ERROR] K8s compute instances could be reached after 60 seconds."
        exit 98
    fi
else
    echo "[ERROR] Could not create K8s cluster infrastructure."
    exit 97
fi

if [ "$?" -eq 0 ]; then
    echo "[ERROR] Could not build K8s cluster."
    exit 1
fi

echo
echo -e "\nElapsed time = $SECONDS seconds."
echo

