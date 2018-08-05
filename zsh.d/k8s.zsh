#!/usr/bin/env zsh

applications=(kompose kops kubectl helm)

for app in $applications; do
	if type $app >/dev/null; then
		source <($app completion zsh)
	fi
done

if type minikube >/dev/null; then
	eval $(minikube docker-env)
	source <(minikube completion zsh)
fi
