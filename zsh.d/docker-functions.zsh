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
