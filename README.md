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
kubectl create secret generic traefik-hub-license --namespace traefik --from-literal=token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6IjkxYmFkZDViLTU3ODItNDI2Mi1iYjhmLTYwYzZiM2I5MzhjMSIsImNsdXN0ZXJJZCI6IjgzYWZlZTJiLTZlOGUtNGJiNy1hNWUwLWQ2ZTBjMGU3MjMyMCIsIndvcmtzcGFjZUlkIjoiNjdkZjA4ZmVlNTdkOTBmZTAwY2MzMzg2IiwiZXhwaXJhdGlvbkRhdGUiOiIyMDI2LTAzLTI0VDAwOjAwOjAwWiJ9.Lf6BFLZ3jxeDedMsBYrcyOl3uGM7Skqtzw_GS9442DycdTCOAAptPm_bf7_vMqoSNxizIhPaIRIiKIwyPUApliEtK5-5KDjAjs7wuDQpMrxK-xUXcU4I-smafjDfweffld-P62900AntPelWtqjeJRRYLv0uxJv8OSodnA1Wzw9BxQpTdNrUcerZEnwgYIj8hBj3Ab6jf5dcNN8-kxHUnt18OITlI01EiHeHv4W9qEEjPmD0LXzGAMtTua_g_4QASpW8MPxnbIr4nb4oMgw4OgV7-Ofm0keBqL8na_IU6lIbQvu7RRWYRGqcIDGOkKY21S4MS26g9wHxzMNSDD7CjYrrT1654DQOn3nK2cajzkP-QBHVtYz9NHaTy-g5tBql9Q629OT_iyo271mGrJ08bjC-UwDbu6j2bi593-H9iKsVgntCLQaaMDnmbCXonkr6o1dzqe91k-mgVZGMDtcqMfM9ow9qcmskuPOa02futKX8diQ7p4oRJwX7jXnxBPKDVhlrTK3eXBUuNrgGcdvMONwif3sc2rUD2G2fboQ5rhEYCi7TipqSXvoZNNF0ue8RAwnLLN9w5Gqg14OJYq8RiJGo3dUh0yphhdcLMaB5LPz8NuSjUx_r-VDzPMM8Ju6VZoMD0xI5lHb1ELgUrr0aunSJ7UBE3rAS2SoYYkf5bd0
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