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
curl http://httpbin.traefik
```

6. Upgrade Traefik from proxy to gateway
```bash
kubectl create secret generic traefik-hub-license --namespace traefik --from-literal=token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6ImQxZWEwMTQxLTdlOGYtNDgyNS05MDlmLWRhMDNiZjk2ODljZiIsImNsdXN0ZXJJZCI6IjdjMDVjN2E3LTM5Y2UtNDU1OS05NGU1LTc4ZGQ5ZTg3NzZhNCIsIndvcmtzcGFjZUlkIjoiNjdkZjA4ZmVlNTdkOTBmZTAwY2MzMzg2IiwiZXhwaXJhdGlvbkRhdGUiOiIyMDI2LTAzLTI0VDAwOjAwOjAwWiJ9.Ddzk_b0nnmjiDp4Xm1zQgaCJ3WI2gasdfJWhO--0TPYmoAeLsCVpasQefvNUyjVzK2CkChgeroIUL_FDMChxrILVANivCdqNvniWzB9I1exeE2llACDiDjpkj7AV0PgTZDnvdkaEuHt18dkHB637XyPTt-zKDsdBF_gyNIUyO3PFXLOdKJx0AoC46-gnCbwB7O_PfszWXrDqWzO7vOGBhoOKL-rIzEW5hRPuGK4zuS6jO-9g_0IJm7Mjjz7SQQ2xFe5MGgVlsJNCm7cGFYADAZrWlmEhcH4CzclWEXmYRVPrdgavTnAFXqvHU7aaIzyof0m79J6ftBz9bB_BWCnvMKEbxCZzCyNH_vKBn5GrW-EkhNRkcuaDEjSmEU2fOZiMayAyYqnktaLivXQdVs3jivADFmzxvUOapaXdaGY9IiRDeJDEo893dR-KoPOBXFy2gFSqsr1rirGhBX2AUPunFHK3IOxbVY3tHRAGsUS_d5r24Yv346GnE_9jZ97xNmqYVJzWXxw_AJVVi9cNe0iXUqFU1N9-70Cn0SYrT7uUTAPZBPC3UXVhueq_rbo79dGF2hBWvbExG3iExY4aFOQ5cnlZFFPu-AcVs_Y-yN6WzLmYYcRddJ4Q_AxNgEa8L-WBy36JEEeeQlhz59pXCAFOOAFVtzYmRrhXZUvoSDaeYBQ
terraform apply -var="azure_subscription_id=$(az account show --query id -o tsv)" -var="enable_api_gateway=true"
```

7. Generate access token for API
```bash
export access_token=$(curl -s -X POST -H 'Content-Type: application/x-www-form-urlencoded' \
https://login.microsoftonline.com/$(terraform output -raw tenant_id)/oauth2/v2.0/token \
-d "client_id=$(terraform output -raw client_id)" \
-d 'grant_type=client_credentials' \
-d "scope=$(terraform output -raw client_id)/.default" \
-d "client_secret=$(terraform output -raw client_secret)" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
```