#!/bin/bash

. ../setup.sh

run "less $(relative app.py)"
run "less $(relative Dockerfile)"
run "docker build -t python-helloworld $(relative .)"
desc "Run Hello-world"
run "docker run -p 4000:80 python-helloworld"

desc "Now run detached"
run "docker run -d -p 4000:80 python-helloworld"
run "curl http://localhost:4000"
run "curl http://localhost:4000"
desc "Run to stop all containers: 'docker stop \$(docker ps -q)'"
run "docker stop $(docker ps -q)"

desc "Tag the docker image"
run "docker tag python-helloworld lastcoolnameleft/python-helloworld:latest"
desc "Push docker image to Docker Hub"
run "docker push lastcoolnameleft/python-helloworld:latest"
desc "View the image on Docker Hub"
run "open https://hub.docker.com/r/lastcoolnameleft/python-helloworld/"
run "docker run -d -p 4000:80 lastcoolnameleft/python-helloworld:latest"
run "curl http://localhost:4000"
run "curl http://localhost:4000"
desc "Run to stop all containers: 'docker stop \$(docker ps -q)'"
run "docker stop $(docker ps -q)"

