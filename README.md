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

5. cURL the exposed routes
```bash
curl http://httpbin.traefik/get
```

6. Upgrade Traefik from proxy to gateway
```bash
terraform apply -var="azure_subscription_id=$(az account show --query id -o tsv)" -var="enable_api_gateway=true"
```

7. Apply gateway middlewares
```bash
kubectl --namespace apps apply -f resources/httpbin/middlewares.gateway.yaml
```

8. Generate access token for API
```bash
export access_token=$(curl -s -X POST -H 'Content-Type: application/x-www-form-urlencoded' \
https://login.microsoftonline.com/$(terraform output -raw tenant_id)/oauth2/v2.0/token \
-d "client_id=$(terraform output -raw client_id)" \
-d 'grant_type=client_credentials' \
-d "scope=$(terraform output -raw client_id)/.default" \
-d "client_secret=$(terraform output -raw client_secret)" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
```

9. Try to access gateway

curl -H "Authorization: Bearer $access_token" http://httpbin.traefik/get