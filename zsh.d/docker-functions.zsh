#!/usr/bin/env zsh

docker-tty() {
	docker run \
		--tty \
		--interactive \
		--rm \
		--user "$(id -u)":"$(id -g)" \
		--volume /etc/passwd:/etc/passwd:ro \
		--volume /etc/group:/etc/group:ro \
		--volume "$(pwd)":/app \
		--workdir /app \
		"$@"
}

compose() {
	docker-tty compose $@
}

yarn-docker() {
	docker-tty node yarn $@
}

npm-docker() {
	docker-tty node npm $@
}

maven() {
	docker-tty maven $@
}

hadolint() {
	docker run --rm -i hadolint/hadolint <$@
}

docker-ip() {
	docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}, {{end}}' "$@"
}

wg() {
	docker run -it --rm --log-driver none -v /tmp:/tmp --cap-add NET_ADMIN --net host --name wg r.j3ss.co/wg "$@"
}

browsh() {
  docker run -it --rm browsh/browsh
}
