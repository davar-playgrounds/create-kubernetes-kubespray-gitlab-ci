# create-kubernetes-kubespray-gitlab-ci
Create kubernetes with kubespray and gitlab-ci

# Prepare Nodes:
## For every node:
```
ssh ip-node 'sudo useradd user_kuber'
ssh ip-node 'echo random-password | sudo passwd user_kuber  --stdin'
ssh ip-node 'sudo usermod -aG wheel user_kuber'
ssh ip-node 'sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config'
ssh ip-node 'sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config'
ssh ip-node "echo 'user_kuber ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user_kuber"
ssh ip-node 'sudo /usr/sbin/reboot'
```

# Generating a new SSH key in repo after inport project
```sh
mkdir .ssh
ssh-keygen -f .ssh/id_rsa
```

# Change ip-node1, ip-node2, ip-node3 to real ip of nodes in:
  - inventory/inventory.cfg
  - .gitlab-ci.yml

# Prepare Kubernetes Cluster

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

