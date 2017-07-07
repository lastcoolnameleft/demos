#git reset --hard
helm delete --purge draft
kubectl delete -n kube-system svc/draftd
export DRAFT_APP_NAME=$(cat draft.toml | toml | jq ".environments.development.name" --raw-output)
kubectl delete deploy/$DRAFT_APP_NAME-$DRAFT_APP_NAME
kubectl delete service/$DRAFT_APP_NAME-$DRAFT_APP_NAME
kubectl delete -n kube-system deploy/tiller-deploy deploy/draftd svc/tiller-deploy

# Must come after 
git clean -dfX

kubectl get all
