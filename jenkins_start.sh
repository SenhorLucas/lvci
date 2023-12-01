#!/bin/bash
# This entire file could be replaced by a well-written `docker-compose.yaml` file

# Containers used
jenkins_dind_container=jenkins-dind-container
jenkins_container=jenkins-blueocean

# Images
dind_image='docker:dind'
jenkins_image='jenkins-blueocean-image:2.414.1-1'


log() {
	printf -- '%s\n' "$@"
}

step() {
	local -r command=$1
	log "Executing: " "$@"
	"$command"
}

create_network_adapter() {
	if ! docker network inspect jenkins &>/dev/null; then
		docker network create jenkins
	else
		log 'Already created'
	fi
}

start_dind_container() {
	if ! docker container inspect "$jenkins_dind_container" &>/dev/null; then
		docker run --name "$jenkins_dind_container" --rm --detach \
			--privileged --network jenkins --network-alias docker \
			--env DOCKER_TLS_CERTDIR=/certs \
			--volume jenkins-data:/var/jenkins_home \
			--volume jenkins-docker-certs:/certs/client \
			--publish 2376:2376 \
			"$dind_image" --storage-driver overlay2
	else
		log "Container $jenkins_dind_container already running"
	fi
}

build_jenkins_image(){
	if ! docker image inspect "$jenkins_image" &>/dev/null; then
		docker build -t "$jenkins_image" ./jenkins-blueocean
	else
		log 'Image already built'
	fi
}

run_jenkins_container() {
	if ! docker container inspect "$jenkins_container" &>/dev/null; then
		docker run --name "$jenkins_container" --restart=on-failure --detach \
			--network jenkins \
			--env DOCKER_HOST=tcp://docker:2376 \
			--env DOCKER_CERT_PATH=/certs/client \
			--env DOCKER_TLS_VERIFY=1 \
			--publish 8080:8080 --publish 50000:50000 \
			--volume jenkins-data:/var/jenkins_home \
			--volume jenkins-docker-certs:/certs/client:ro \
			"$jenkins_image"
	else
		log 'Jenkins container already running'
	fi
}

exec_jenkins_container() {
	docker exec -it jenkins-blueocean /bin/bash
}


main() {
	case $1 in
		setup)
			step create_network_adapter
			step start_dind_container
			step build_jenkins_image
			step run_jenkins_container
			;;
		exec) step exec_jenkins_container;;
		status)
			docker container stats --no-stream jenkins-blueocean jenkins-docerk;;
		*) log 'Options: setup, exec';;
	esac
}

main "$@"
