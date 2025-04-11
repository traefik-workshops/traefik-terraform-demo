1. Deploy resources

```bash
terraform apply -auto-approve -var="subscription_id=$(az account show --query id -o tsv)"
```

2. Get AKS credentials and connect to the cluster

```bash
export RESOURCE_GROUP=$(terraform output -raw resource_group_name)
export CLUSTER_NAME=$(terraform output -raw cluster_name)
az aks get-credentials  --overwrite-existing --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME
```