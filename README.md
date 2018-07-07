# Create kubernetes cluster using kubespray and gitlab ci
Create kubernetes with kubespray and gitlab-ci

# Prepare Nodes:

# Change ip-node1, ip-node2, ip-node3 to real ip of nodes in:
  - inventory/inventory.cfg
  - .gitlab-ci.yml
  - prepare-nodes.sh

# Generating a new SSH key in repo after inport project
```sh
mkdir .ssh
ssh-keygen -f .ssh/id_rsa
```

# Run prepare nodes
```sh
./prepare-nodes.sh
```

# Run gitlab runner register on every nodes
```sh
gitlab-ci-multi-runner register
```
Please enter the default Docker image (e.g. ruby:2.1):
ubuntu:18.04

## Change clusterip to nodeport command line without editor
```sh
kubectl -n kube-system get service kubernetes-dashboard -o yaml > kube-dash-svc.yaml
sed 's/ClusterIP/NodePort/' kube-dash-svc.yaml > new-kube-dash-svc.yaml
kubectl delete svc kubernetes-dashboard --namespace kube-system
kubectl create -f new-kube-dash-svc.yaml
```
or
```sh
kubectl patch svc kubernetes-dashboard --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
```

## Create admin
```sh
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
```
## Get NodePort
```sh
kubectl get svc --all-namespaces -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'
```
## Go https://real-ip-node:$nodeport

## Get token
```sh
kubectl describe secret
```

