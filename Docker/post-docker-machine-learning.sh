Build image in Docker
$ docker build -t oficina-ml .

Check the image name
$ docker images

Run the container with the machine learning space
$ docker run --name oficina-ml -p 8888:8888 -v "$PWD/notebooks:/opt/notebooks" -d oficina-ml

Tagging the image
$ docker tag 7e94b5c03aea nova6/oficina-ml:latest

Login no Dockerhub
$ docker login

Push in the image to Dockerhub
$ docker push nova6/oficina-ml

Remove the image in your local machine
$ docker rmi -f 4048f45d3323

Execution of the image using the run command
$ docker run nova6/oficina-ml

Push in the remote repo
$ docker push nova6/oficina-ml

Run the image locally
$ docker run -p 8888:8888 nova6/oficina-ml

Bash inside the image
$ docker exec -i -t c2f1db72e707 /bin/bash

Stop all containers
$ docker stop $(docker ps -q)

Kill all containers
$ docker kill $(docker ps -q)

Remove all containers
$ docker rm -f $(docker ps -q)

Purge everything unused
$ docker ps -q | xargs -r docker stop ; docker system purge -a
