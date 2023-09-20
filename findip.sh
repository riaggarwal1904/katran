#!/bin/bash

# Check if external IP is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <EXTERNAL_IP>"
    exit 1
fi

EXTERNAL_IP=$1

# Find the Service based on External IP
SERVICE_NAME=$(kubectl get services --no-headers | grep $EXTERNAL_IP | awk '{print $1}')
if [ -z "$SERVICE_NAME" ]; then
    echo "No service found with external IP $EXTERNAL_IP"
    exit 1
fi

echo "Service Name: $SERVICE_NAME"

# Find the Pods associated with the Service
SELECTOR_LABELS=$(kubectl describe service $SERVICE_NAME | grep Selector | awk '{print $2}')
POD_NAMES=$(kubectl get pods -l $SELECTOR_LABELS --no-headers | awk '{print $1}')

echo "Pods associated with the service:"
echo "$POD_NAMES"

# Find the Node (VM) on which the Pod is running and its IP
declare -A NODE_IPS_ARRAY

echo ""
echo "Pods running on nodes:"
for POD_NAME in $POD_NAMES; do
    NODE_NAME=$(kubectl get pod $POD_NAME -o=jsonpath='{.spec.nodeName}')
    NODE_IP=$(kubectl get nodes $NODE_NAME -o=jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
    echo "Pod: $POD_NAME is running on Node: $NODE_NAME with IP: $NODE_IP"
    NODE_IPS_ARRAY[$NODE_IP]=1
done

PREVIOUS_IPS_FILE="previous_ips.txt"
declare -A PREVIOUS_IPS_ARRAY

# Load previous IPs from file into an associative array
if [[ -f $PREVIOUS_IPS_FILE ]]; then
    while read -r line; do
        PREVIOUS_IPS_ARRAY[$line]=1
    done < $PREVIOUS_IPS_FILE
fi

# For each previously seen IP, check if it's still present. If not, delete it.
for IP in "${!PREVIOUS_IPS_ARRAY[@]}"; do
    if [[ -z ${NODE_IPS_ARRAY[$IP]} ]]; then
        echo "Removing IP: $IP"
        ./katran_goclient -d -t 10.0.1.65:3456 -r $IP
    fi
done

# For each current IP, if it was not seen before, add it.
for IP in "${!NODE_IPS_ARRAY[@]}"; do
    if [[ -z ${PREVIOUS_IPS_ARRAY[$IP]} ]]; then
        echo "Adding IP: $IP"
        ./katran_goclient -a -t 10.0.1.65:3456 -r $IP
    fi
done

# Save current IPs to the file for the next run
printf "%s\n" "${!NODE_IPS_ARRAY[@]}" > $PREVIOUS_IPS_FILE

./katran_goclient -l