# monitoring-stack-terraform
monitoring stack(prometheus, grafana, alertmanager, exporters, etc) deploying in kuber by terraform


- kubernetes_host, kubernetes_token

```
export TF_VAR_kubernetes_host=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
export TF_VAR_kubernetes_token=$(kubectl get secret $(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode )
```

Or
```
kubectl create serviceaccount k8sadmin -n kube-system
kubectl create clusterrolebinding k8sadmin --clusterrole=cluster-admin --serviceaccount=kube-system:k8sadmin
export TF_VAR_kubernetes_host=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
export TF_VAR_kubernetes_token=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | (grep k8sadmin || echo "$_") | awk '{print $1}') | grep token: | awk '{print $2}')
```

- check
```
curl $TF_VAR_kubernetes_host/api --header "Authorization: Bearer $TF_VAR_kubernetes_token" --insecure
```
