echo Running: ../python-docker/cleanup.sh
../python-docker/cleanup.sh
echo Deleteing deployments
kubectl delete deploy/python-helloworld
kubectl delete deploy/redis
echo Deleteing services
kubectl delete service/python-helloworld
kubectl delete service/redis
echo Deleting Helm charts
helm delete $(helm list | grep mediawiki | cut -f 1)
helm delete $(helm list | grep minecraft | cut -f 1)
rm *.tgz
echo Running: killall kubectl
killall kubectl
