#!/bin/bash

. ../setup.sh

RESOURCE_GROUP=tmp-k8s

desc "Deploy the Infrastructure for the Kubernetes cluster"

desc "Run in a separate window:"
desc "az group create -n $RESOURCE_GROUP -l southcentralus"
desc "time az acs create -g $RESOURCE_GROUP -n $RESOURCE_GROUP -t Kubernetes --admin-username thfalgou"
run ""

../python-docker/demo.sh

# From now on, assuming we have a working K8S Cluster on Azure

desc "...Is the Kubernetes cluster up yet?"
run ""
run "open https://ms.portal.azure.com/#resource/subscriptions/df8428d4-bc25-4601-b458-1c8533ceec0b/resourceGroups/$RESOURCE_GROUP/overview"
desc "Pull Kubernetes config down to local host"
run "az acs kubernetes get-credentials -g $RESOURCE_GROUP -n $RESOURCE_GROUP"
desc "From now on, we can use Kubernetes native cli"

desc "Run kubectl proxy in background"
run 'kubectl proxy &'
run 'open http://localhost:8001/ui'
run 'kubectl get all'
desc "pod = group of one+ containers, the shared storage and options on how to run the containers"

desc "Run python-helloworld"
run 'kubectl run python-helloworld --image lastcoolnameleft/python-helloworld:latest'
desc "Watch the deployment"
run 'watch kubectl get all'
desc "Scale the # of instances of python-helloworld to 3"
run 'kubectl scale --replicas=3 deployment/python-helloworld'
run 'watch kubectl get all'

desc "Expose the python-helloworld service to the world.  Takes ~3 minutes"
run 'kubectl expose deployments python-helloworld --port=80 --type=LoadBalancer'
run "open https://ms.portal.azure.com/#resource/subscriptions/df8428d4-bc25-4601-b458-1c8533ceec0b/resourceGroups/$RESOURCE_GROUP/overview"
run 'watch kubectl get all'

run 'export SERVICE_IP=$(kubectl get svc/python-helloworld --output json | jq --raw-output ".status.loadBalancer.ingress[0].ip")'
run 'echo $SERVICE_IP'
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"

desc "Now enable Redis to count visits"
run 'kubectl run redis --image redis'
run 'kubectl expose deployment/redis --port=6379'
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"
run "curl $SERVICE_IP"


desc "What if you want to install not just a single docker image, but an entire application?"
desc "For example, MediaWiki, which has both the application + the DB."
run "helm init"
run "open https://helm.sh/"
run "helm install stable/mediawiki"

run "open http://github.com/kubernetes/charts/tree/master/stable"

desc "What if we want to run something more interesting..."
run "helm install --set minecraftServer.eula=true stable/minecraft"
run 'watch kubectl get all'

desc "Let's talk about monitoring containers"
run "open https://thfalgou-k8s.portal.mms.microsoft.com"
run "open https://docs.microsoft.com/en-us/azure/container-service/container-service-kubernetes-oms"

desc "Hope you enjoyed!"
