#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting K3s installation...${NC}"

k3sup install \
  --cluster \
  --host $HOST \
  --user $USER \
  --ssh-key $KEY \
  --k3s-extra-args '--disable traefik --disable flannel --disable servicelb' \
  --merge \
  --local-path $HOME/.kube/config \
  --context home-ops-k3s \
  --k3s-version v1.31.4+k3s1

if [ $? -eq 0 ]; then
  echo -e "${GREEN}K3s installation completed successfully!${NC}"
else
  echo -e "${RED}K3s installation failed.${NC}"
fi
