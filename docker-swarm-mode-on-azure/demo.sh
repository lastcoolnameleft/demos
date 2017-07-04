#!/bin/bash

. ../setup.sh

desc "Generate ACS Engine"
run "vi acs-engine-swarm-mode.json"
run "acs-engine generate acs-engine-swarm-mode.json"

desc "Deploy the Infrastructure for the Swarm cluster"

desc "Run in a separate window:"
desc "time az group create -n sandbox-swarm-mode -l southcentralus"
desc "time az group deployment create -n sandbox-swarm-mode -g sandbox-swarm-mode --template-file _output/thfalgou-swarm-master/azuredeploy.json --parameters _output/thfalgou-swarm-master/azuredeploy.parameters.json"
run ""
run "open https://ms.portal.azure.com/#resource/subscriptions/df8428d4-bc25-4601-b458-1c8533ceec0b/resourceGroups/sandbox-swarm-mode/overview"

run "cd python"
run "vi app.py"
run "vi Dockerfile"
run "docker build -t python-helloworld ."
desc "Run Hello-world"
run "docker run -p 4000:80 python-helloworld"

# desc "Now run detached"
#docker run -d -p 4000:80 python-helloworld
#docker ps

desc "Tag the docker image"
run "docker tag python-helloworld lastcoolnameleft/python-helloworld:latest"
desc "Push docker image to Docker Hub"
run "docker push lastcoolnameleft/python-helloworld:latest"
desc "View the image on Docker Hub"
run "open https://hub.docker.com/r/lastcoolnameleft/python-helloworld/"
run "docker run -p 4000:80 lastcoolnameleft/python-helloworld:latest"

desc "Create a Docker Swarm cluster of one node"
desc "Swarm = group of machines running Docker and joined to a cluster"
run "docker swarm init"
desc "Create a Docker Stack using docker-compose.yml"
run "vi docker-compose.yml"
run "docker stack deploy -c docker-compose.yml getstartedlab"
run "docker stack ps getstartedlab"
run "curl http://localhost"
run "curl http://localhost"
run "curl http://localhost"
run "curl http://localhost"
run "curl http://localhost"
run "curl http://localhost"

desc "change replica value and redeploy"
run "vi docker-compose.yml"
run "docker stack deploy -c docker-compose.yml getstartedlab"
run "docker stack ps getstartedlab"

desc "done with stack."
run "docker stack rm getstartedlab"
run "docker stack ps getstartedlab"
run "docker node ls"

desc "CREATE A CLUSTER LOCALLY"
desc "Create 2 VM's"
run "docker-machine create --driver virtualbox myvm1 &"
run "docker-machine create --driver virtualbox myvm2 &"
desc "<insert joke here while waiting for VM to boot>"
desc "Init Swarm on vm1"
desc "Might hit --advertise-addr issue"
run "docker-machine ssh myvm1 'docker swarm init'"
desc "Run 'docker-machine env myvm1'"
run "docker-machine ssh myvm1 'docker swarm init --advertise-addr 192.168.99.100:2377'"

desc "Add vm2 to the swarm by running the 'docker swarm join' command"
run "docker-machine ssh myvm2 "
desc "Congrats!  We've made a swarm."
run "docker-machine ssh myvm1 'docker node ls'"

desc "Create Swarm on cluster"
run "docker-machine scp docker-compose.yml myvm1:~"
run "docker-machine ssh myvm1 'docker stack deploy -c docker-compose.yml getstartedlab'"
run "docker-machine ssh myvm1 'docker stack ls'"
run "docker-machine ssh myvm1 'docker stack ps getstartedlab'"

desc "Look at service running"
run "docker-machine ls"
desc "...takes a few seconds to start up..."
sleep 5
run "curl 192.168.99.100"
run "curl 192.168.99.100"
run "curl 192.168.99.100"
run "curl 192.168.99.101"
run "curl 192.168.99.101"
run "curl 192.168.99.101"

desc "now add visualizer"
run "vi docker-compose-visualizer.yml"
run "diff docker-compose.yml docker-compose-visualizer.yml"
run "docker-machine scp docker-compose-visualizer.yml myvm1:~"
run "docker-machine ssh myvm1 'docker stack deploy -c docker-compose-visualizer.yml getstartedlab'"
desc "...takes a few seconds to start up..."
sleep 10
run "open http://192.168.99.100:8080/"

desc "validate the lab"
run "docker-machine ssh myvm1 'docker stack ps getstartedlab'"

desc "now add redis"
run "vi docker-compose-redis.yml"
run "diff docker-compose-visualizer.yml docker-compose-redis.yml"
run "docker-machine scp docker-compose-redis.yml myvm1:~"
run "docker-machine ssh myvm1 'docker stack deploy -c docker-compose-redis.yml getstartedlab'"
desc "...takes a few seconds to start up..."
sleep 5
run "open http://192.168.99.100:8080/"
run "curl http://192.168.99.101"
run "curl http://192.168.99.100"
run "curl http://192.168.99.100"
run "curl http://192.168.99.100"
run "curl http://192.168.99.100"


# Demonstrated how to Docker locally.  Let's look at swarm.
# go to cloud.docker.com
#  Will redirect to https://cloud.docker.com/swarm/lastcoolnameleft/dashboard/onboarding/cloud-registry
# Click "Swarms"
# Click "Bring your own swarm"
# Copy Registation command

#ssh thfalgou-swarm-master.southcentralus.cloudapp.azure.com
# Run registration commnd.

# Let's copy docker-swarm-redis.yml
desc "Now copy the Docker compose file to the Azure Swarm Master"
run "scp docker-compose-redis.yml  thfalgou-swarm-master.southcentralus.cloudapp.azure.com:"
desc "Now start the Docker stack"
desc "docker stack deploy -c docker-compose-redis.yml getstartedlab"
desc "docker stack ls"
desc "docker stack ps getstartedlab"
run "ssh thfalgou-swarm-master.southcentralus.cloudapp.azure.com"

desc "TADA!"
