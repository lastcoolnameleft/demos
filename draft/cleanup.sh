git reset --hard
git clean -df
helm delete --purge draft
kubectl delete -n kube-system svc/draftd
