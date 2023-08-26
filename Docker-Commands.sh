### Docker commands
## The docker daemon needs to be up and running to use these commands. Open Docker Desktop on Windows to start the daemon

## Image commands

docker pull <Image-name:tag>  #to pull image from a docker registry

docker images  #to list current images in your local registry OR [$docker image ls]

docker rmi <Image-name:tag>  #To remove the specified image from local registry
docker rmi <image1> <image2>  #Can delete multiple images by specifying the name or ID

docker rmi -f $(docker images)  #Remove all the images listed out by the [$docker images] command

docker search <Image-name>  #To search for an Image-name from a public registry

docker save <Image-name>  >  filename.tar  #To save an image in .tar/.zip format and share with other people.
#Can also run [$docker save image -o file.tar]

docker image load --input <file-name>  #To load a docker image from a tar file back into the local repository

docker inspect

###################################################################################################
## Container Commands

docker run <Image-name>  #to start and run a container

docker run --detached <Image-name> # OR '-d'
#to run docker in detached mode or backgroud mode so you can have access to your terminal while container runs in the backend.

docker run -d -p <host-port:container-port> --name <container-name> <image> 
#to start a container in detached mode, passing port binding from your host to container port and providing a name to the container.

docker ps # to list containers in a running state

docker ps -a # To list all containers .. irrespective of whether they are exited or running

docker ps -a -q # To list containers by their ID's

docker logs <containerID> #Display logs for running container

docker stop <containerID> #To stop a specific container 

docker start <containerID> #To start a stopped container

docker rm <containerID> #to delete a specific container ..Note# must confirm container is deleted by rinting out the container ID

docker rm -f $(docker ps -aq) # Forcefully remove all containers without stopping them

docker run -it ubuntu bash #to start the ubuntu container and log into it

docker exec <containerID> -- cat /etc/*release*  #to list OS details of the container

docker commit <containerID> <name>

docker exec -it <containerID> bash  # '-it' = interctive mode, to login to the container using a bash terminal, similar to ssh

#################################################################################################

### Dockerfile

#A Dockerfile is a text document that contains all the commands you would normally execute manually in order to build a Docker image. 
#Docker can build images automatically by reading the instructions from a Dockerfile.

FROM ubuntu
LABEL project="jjtech"
RUN apt update
RUN apt full-upgrade -y && apt install python-pip -y
RUN pip2 install flask
WORKDIR /opt
COPY app.py /opt/app.py
ENTRYPOINT FLASK_APP=/opt/app.py flask run --host=0.0.0.0 --port=8080
----------------------------------------------------------------------------------------------------

docker build -t <image-name:1.0>  .
dokcer build -t <image-name:1.0> -f path/to/dockerfile .
# The ' . ' at the end specifies that the build context is in the current directory.
# build context is where the Docker daemon looks for files to include in the image.

docker run --name <container-name> -d -p 8000:8080 <image-name:tag>



###################################################################################################
## Docker Named volumes
# These are stored in the Docker storage directory.

docker volume create <volume-name>
docker volume ls
docker inspect <volume-name>
docker volume rm <volume-name>

# TO start container with volume mounted on /opt within the container
docker run -d -p host-port:cont-port \
  --name container-name \
  -v volume-name:/opt \
  image-name

docker run --name container-name -v c:/Users/Anselme/Documents/Demos/docker/website:/usr/share/nginx/html -d -p 9000:80 nginx

docker run -d -p 9000:80 -v c:/Users/Anselme/Documents/Demos/docker/website:/usr/share/nginx/html -v c:/Users/Anselme/Documents/Demos/docker/logs:/var/log/nginx --name container-name Image-name


## Bind mounts
#Another form of persistant storage, uses a local host file or directory as container mount, must use the absolute path

# To start container with volume mounted on /opt within the container, "$pwd" returns the absolute path of current directory
docker run -d \
  -it \
  --name container-name \
  -v /$(pwd):/opt \
  image-name
#OR
docker run -v <host-path:container-path> <image>

#Mount the website_docker-volume directory to nginx container which listens on port 80.
docker run --name nginx-docker -v /$(pwd)/website_docker-volume:/usr/share/nginx/html -d -p 9000:80 nginx
