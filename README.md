# traefik-terraform-demo

1. Initialize Terraform
```bash
terraform init
```

2. Create the AKS cluster
```bash
terraform apply -var="azure_subscription_id=$(az account show --query id -o tsv)"
```

3. Update the hosts file
```bash
sudo ./update-hosts.sh
```

4. Create the security module
```bash
kubectl create namespace apps
kubectl --namespace apps apply -f resources/httpbin/app.yaml
kubectl --namespace apps apply -f resources/httpbin/middlewares.yaml
kubectl --namespace apps apply -f resources/httpbin/route.yaml
```

5. 
