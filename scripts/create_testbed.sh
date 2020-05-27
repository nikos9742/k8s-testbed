#!/bin/bash


set -e

echo 'Start script'
date

# Create Kubernetes cluster on DigitalOcean Cloud 
doctl kubernetes cluster create testbed-k8s-$(date +%s) --region ams3 --node-pool "size=s-4vcpu-8gb;auto-scale=true;min-nodes=3;max-nodes=20"

# Get and install kube-state-metrics on the cluster
DIR=./kube-state-metrics
if test -d "$DIR" 
then
    echo "kube-state-metrics directory exists"
    cd kube-state-metrics/
    git fetch
    cd ..

else 
    echo "kube-state-metrics doesn't exist"
    echo "Cloning :"
    git clone https://github.com/kubernetes/kube-state-metrics.git
fi

kubectl create -f kube-state-metrics/examples/standard/

echo 'Wait 5m for pods deployment'
sleep 2m

# Check cluster prequisite for linkerd and install linkerd
linkerd check --pre 
linkerd install --ha --controller-replica=2 | kubectl apply -f -

# Get and install full microservice demo app
DIR2=./microservices-demo
if test -d "$DIR2" 
then
    echo "microservices-demo directory exists"
    cd microservices-demo/
    git fetch
    cd ..

else 
    echo "My directory doesn't exist"
    echo "Cloning :"
    git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
fi

kubectl apply -f ./microservices-demo/release/kubernetes-manifests.yaml
kubectl get pods --all-namespaces

echo 'Wait 5m for pods deployment'
sleep 2m
kubectl get pods --all-namespaces

kubectl get -n default deploy -o yaml \
  | linkerd inject - --proxy-cpu-limit 400m --proxy-cpu-request 200m \
  | kubectl apply -f -

kubectl get pods --all-namespaces
echo 'Wait 2m for pods deployment'
sleep 2m

kubectl get pods --all-namespaces


DIR3=./kube-prometheus
if test -d "$DIR3" 
then
    echo "kube-prometheus directory exists"
    cd kube-prometheus/
    git fetch
    cd ..

else 
    echo "kube-prometheus doesn't exist"
    echo "Cloning :"
    git clone https://github.com/coreos/kube-prometheus.git
fi

# Create the namespace and CRDs, and then wait for them to be availble before creating the remaining resources
kubectl create -f ./kube-prometheus/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl create -f ./kube-prometheus/manifests/ || true

kubectl create -f ./../manifest/federation-manifest.yaml || true
kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --serviceaccount=monitoring:prometheus-k8s || true
kubectl create clusterrolebinding root-cluster-admin-binding2 --clusterrole=cluster-admin --serviceaccount=monitoring:kube-state-metrics || true
kubectl create clusterrolebinding root-cluster-admin-binding3 --clusterrole=cluster-admin --serviceaccount=monitoring:prometheus-adapter || true

#I know it's not safe
kubectl get pods --all-namespaces
echo 'Wait 5m for pods deployment'
sleep 2m
kubectl get pods --all-namespaces

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
helm install -n monitoring prom-adapter -f ./../manifest/values-adapter.yaml stable/prometheus-adapter
echo -n 'End script'
date
