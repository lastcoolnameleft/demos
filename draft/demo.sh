#!/bin/bash

# Requires https://www.npmjs.com/package/toml-cli

. ../setup.sh

RESOURCE_GROUP=${RESOURCE_GROUP:-sandbox-k8s}
ACR_NAME=${ACR_NAME:-thfalgoudemoacr}
BASE_DOMAIN=${BASE_DOMAIN:-draft.local}

desc "Demo of Kubernetes Draft"
if [ -z "$TMUX" ]; then echo "Make sure you are in tmux" && exit 1; fi

desc "If you're awesome, you're already using K8S on ACS and you can pull down the K8S Config easily:"
desc "az acs kubernetes get-credentials -g $RESOURCE_GROUP -n $RESOURCE_GROUP"

desc "To Create the Azure Container Registry:"
desc "az acr create -n $ACR_NAME -g $RESOURCE_GROUP --admin-enabled --sku Basic"
desc "Get the ACR password:"
desc "az acr credential show --name $ACR_NAME --query passwords[0].value"

desc "Draft uses Helm to deploy"
run "helm init"
run "helm install stable/nginx-ingress --namespace=kube-system --name=nginx-ingress"

run "draft init"

run "cd python"
run "ls"

run "draft create"

desc "Draft has detected the project type and added new files"

run "cat draft.toml"
run "cat Dockerfile"

tmux split-window -v
tmux split-window -h
tmux send-keys -t 1 "draft up"
tmux send-keys -t 2 "watch kubectl get all"

tmux select-pane -t 0
read -s

desc "Don't forget to update /etc/hosts with endpoint"
desc "kubectl --namespace kube-system get services nginx-ingress-nginx-ingress-controller"
run 'export SERVICE_IP=$(kubectl --namespace kube-system get services nginx-ingress-nginx-ingress-controller --output json | jq --raw-output ".status.loadBalancer.ingress[0].ip")'
run 'echo $SERVICE_IP'
run 'export DRAFT_APP_NAME=$(cat draft.toml | toml | jq ".environments.development.name" --raw-output)'
run 'echo $DRAFT_APP_NAME'
desc "Run in a separate window:"
desc "echo $SERVICE_IP $DRAFT_APP_NAME.$BASE_DOMAIN | sudo tee -a /etc/hosts"

desc "Now make a change to the application"
run "vi app.py"

desc "Draft will package and deploy the new application"
run "watch curl -s $DRAFT_APP_NAME.$BASE_DOMAIN"

