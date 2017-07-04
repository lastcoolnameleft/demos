az group delete -n sandbox-swarm-mode -y
docker swarm leave --force
docker-machine rm myvm1 --force
docker-machine rm myvm2 --force
sed -i '' '/thfalgou-swarm-master.southcentralus.cloudapp.azure.com/d' /Users/thfalgou/.ssh/known_hosts
