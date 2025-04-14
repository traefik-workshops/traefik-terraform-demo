```bash
export access_token=$(curl -s -X POST -H 'Content-Type: application/x-www-form-urlencoded' \
  https://login.microsoftonline.com/$(terraform output -raw tenant_id)/oauth2/v2.0/token \
  -d "client_id=$(terraform output -raw client_id)" \
  -d 'grant_type=client_credentials' \
  -d "scope=$(terraform output -raw client_id)/.default" \
  -d "client_secret=$(terraform output -raw client_secret)" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
```
