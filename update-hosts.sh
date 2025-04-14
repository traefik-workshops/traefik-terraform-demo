#!/bin/bash

# Get the Traefik IP from terraform output
TRAEFIK_IP=$(terraform output -raw traefik_ip)

# Initialize empty DOMAINS array
DOMAINS=()

# Get the exposed URLs and convert to array
while IFS= read -r url; do
    # Extract hostname from URL (remove http:// and :8080 if present)
    hostname=$(echo "$url" | sed 's|http://||' | sed 's|:8080||')
    DOMAINS+=("${TRAEFIK_IP} ${hostname}")
done < <(terraform output -json exposed_urls | jq -r '.[]')

# Path to hosts file
HOSTS_FILE="/etc/hosts"

# Comment marker to identify our entries
MARKER="# Traefik Demo Domains"

# Remove existing entries between markers
sed -i '' "/$MARKER/,/$MARKER/d" "$HOSTS_FILE"

# Add new entries
echo "$MARKER" | sudo tee -a "$HOSTS_FILE" > /dev/null
for DOMAIN in "${DOMAINS[@]}"; do
  echo "$DOMAIN" | sudo tee -a "$HOSTS_FILE" > /dev/null
done
echo "$MARKER" | sudo tee -a "$HOSTS_FILE" > /dev/null

echo "Hosts file updated successfully!"
echo "Added the following entries:"
for DOMAIN in "${DOMAINS[@]}"; do
  echo "$DOMAIN"
done
