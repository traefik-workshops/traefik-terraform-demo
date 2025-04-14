#!/bin/bash

# Get the Traefik IP from terraform output
TRAEFIK_IP=$(terraform output -raw traefik_ip)
TRAEFIK_DASHBOARD_URL=$(terraform output -raw treafik_dashboard_url | sed 's|http://||' | sed 's|:8080||')
TRAEFIK_GRAFANA_URL=$(terraform output -raw treafik_grafana_url | sed 's|http://||' | sed 's|:8080||')
TRAEFIK_PROMETHEUS_URL=$(terraform output -raw treafik_prometheus_url | sed 's|http://||' | sed 's|:8080||')
TRAEFIK_KEYCLOAK_URL=$(terraform output -raw treafik_keycloak_url | sed 's|http://||' | sed 's|:8080||')

# Define the domains
DOMAINS=(
  "${TRAEFIK_IP} ${TRAEFIK_DASHBOARD_URL}"
  "${TRAEFIK_IP} ${TRAEFIK_GRAFANA_URL}"
  "${TRAEFIK_IP} ${TRAEFIK_PROMETHEUS_URL}"
  "${TRAEFIK_IP} ${TRAEFIK_KEYCLOAK_URL}"
)

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
