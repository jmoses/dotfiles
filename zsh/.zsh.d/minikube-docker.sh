if hash minikube &> /dev/null ; then
    echo "Loading docker env"
    eval $(minikube -p minikube docker-env)
fi
