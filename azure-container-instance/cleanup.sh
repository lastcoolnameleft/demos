echo Deleting Resource group
RESOURCE_GROUP=${RESOURCE_GROUP:-sandbox-aci}
az group delete --name $RESOURCE_GROUP
