# monitoring-stack-terraform
monitoring stack(prometheus, grafana, alertmanager, exporters, etc) deploying in kuber by terraform

## Enviroment
For kubernetes in GKE
1. get credentials

gcloud container clusters get-credentials gke-cluster-mbelousov-kubernetes-laba --zone us-east1-b --project <your project name>

for example
```
gcloud container clusters get-credentials gke-cluster-mbelousov-kubernetes-laba --zone us-east1-b --project mbelousov-kubernetes-laba
```


2. add enviroment variables kubernetes_host, kubernetes_token

```
kubectl create serviceaccount k8sadmin -n kube-system
kubectl create clusterrolebinding k8sadmin --clusterrole=cluster-admin --serviceaccount=kube-system:k8sadmin
export TF_VAR_kubernetes_host=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
export TF_VAR_kubernetes_token=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | (grep k8sadmin || echo "$_") | awk '{print $1}') | grep token: | awk '{print $2}')
```

3. check
```
curl $TF_VAR_kubernetes_host/api --header "Authorization: Bearer $TF_VAR_kubernetes_token" --insecure
```

## Terraform
```
terraform init
terraform apply -var-file="./secrets/secrets.tfvars" -auto-approve
```

## configure ssl cert
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx.key -out nginx.crt

## Offline deploy

export TF_VAR_kubernetes_host=<https://API-ENDPOUNT:6443>
export TF_VAR_kubernetes_token=<SA TOKEN>

1. On oline host

```
cd git_repo/<enviroment dir>
terraform providers mirror -platform=linux_amd64 </path_for_providers/>
```

2. On offline host
Prepare binaries

```
mkdir ~/terraform
cp <@/path_for_binary/terraform> ~/terraform/terraform
cp <@online_host:/path_for_providers/> ~/terraform/providers

cd git_repo/<enviroment dir>
~/terraform/terraform init -plugin-dir=~/terraform/providers
```

Prepare enviroment variables
```
export TF_VAR_kubernetes_host=<https://API-ENDPOUNT:6443>
export TF_VAR_kubernetes_token=<SA TOKEN>
