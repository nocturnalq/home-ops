#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting K3s installation...${NC}"

k3sup install \
  --ip <SERVER_IP> \
  --user <SSH_USER> \
  --ssh-key <PATH_TO_SSH_KEY> \
  --k3s-extra-args '--disable traefik --disable flannel'

if [ $? -eq 0 ]; then
  echo -e "${GREEN}K3s installation completed successfully!${NC}"
else
  echo -e "${RED}K3s installation failed.${NC}"
fi