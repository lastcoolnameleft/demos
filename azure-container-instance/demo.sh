#!/bin/bash

. ../setup.sh

RESOURCE_GROUP=${RESOURCE_GROUP:-sandbox-aci}
CONTAINER_IMAGE=${CONTAINER_IMAGE:-microsoft/aci-helloworld}

desc "This demo showcases the Azure Container Instance"
desc "--> Create the Resource Group"
run "az group create --name $RESOURCE_GROUP --location eastus"

desc "--> Create the Container Instance"
run "az container create --name $CONTAINER_IMAGE --image $CONTAINER_IMAGE --resource-group $RESOURCE_GROUP --ip-address public"

desc "--> Wait for the instance to be available"
run "az container show --name $CONTAINER_IMAGE --resource-group $RESOURCE_GROUP"

desc "--> Fetch the Logs"
run "az container logs --name $CONTAINER_IMAGE --resource-group $RESOURCE_GROUP"

desc "--> Fetch the IP"
run 'export IP=$(az container show --name $CONTAINER_IMAGE --resource-group $RESOURCE_GROUP | | jq -r ".ipAddress.ip)"'
run 'echo $IP'

desc "--> Curl the URL"
run "curl $IP"
run "curl $IP"

desc "--> Fetch the Logs"
run "az container logs --name $CONTAINER_IMAGE --resource-group $RESOURCE_GROUP"

desc "--> Delete the container"
run "az container delete --name $CONTAINER_IMAGE --resource-group $RESOURCE_GROUP"

