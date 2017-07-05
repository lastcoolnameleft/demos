#!/bin/bash

# Not tested yet

. ../setup.sh

RESOURCE_GROUP=sandbox-windows-k8s

run "open https://docs.microsoft.com/en-us/azure/container-service/container-service-kubernetes-windows-walkthrough"

run "az group create -n $RESOURCE_GROUP -l southcentralus"

run "acs create -g $RESOURCE_GROUP -n $RESOURCE_GROUP -t Kubernetes --windows  --admin-password 'FooBar!@#'"

run "acs kubernetes get-credentials -g $RESOURCE_GROUP -n $RESOURCE_GROUP"

run "vi iis.json"

run "kubectl apply -f iis.json"

run "kubectl expose pods iis --port=80 --type=LoadBalancer"

run "vi simpleweb.json"

run "kubectl expose pods simpleweb  --port=80 --type=LoadBalancer"

