#!/bin/bash

. ../setup.sh

RESOURCE_GROUP=sandbox-k8s
ACR_NAME=thfalgoutdemoacr

desc "Demo of Kubernetes Draft"
if [ -z "$TMUX" ]; then echo "Make sure you are in tmux" && exit 1; fi

desc "If you're awesome, you're already using K8S on ACS and you can pull down the K8S Config easily:"
desc "az acs kubernetes get-credentials -g $RESOURCE_GROUP -n $RESOURCE_GROUP"

desc "az acr create -n $ACR_NAME -g $RESOURCE_GROUP --admin-enabled --sku Basic"

desc "Draft uses Helm to deploy"
run "helm init"
run "helm install stable/nginx-ingress --namespace=kube-system --name=nginx-ingress"

#run "draft init"

run "cd python"
run "ls"

run "draft create"

desc "Draft has detected the project type and added new files"

run "cat draft.toml"
run "cat Dockerfile"

tmux split-window -v
tmux select-layout even-vertical
tmux select-pane -t 0

tmux send-keys -t 1 "draft up"

read -s

desc "Don't forget to update /etc/hosts with endpoint"
desc "kubectl --namespace kube-system get services nginx-ingress-nginx-ingress-controller"
run 'export SERVICE_IP=$(kubectl --namespace kube-system get services nginx-ingress-nginx-ingress-controller --output json | jq --raw-output ".status.loadBalancer.ingress[0].ip")'
run 'echo $SERVICE_IP'
desc "Add to /etc/hosts: $SERVICE_IP <draft host>"

run ""
run "sudo vi /etc/hosts"

desc "Now make a change to the application"
run "vi app.py"

desc "Draft will package and deploy the new application"
desc "In other window: watch curl -s <draft host>"
run "watch kubectl get all"

