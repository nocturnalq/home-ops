#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Getting K3s config...${NC}"

k3sup install \
  --cluster \
  --host $HOST \
  --user $USER \
  --ssh-key $KEY \
  --merge \
  --local-path $HOME/.kube/config \
  --context home-ops-k3s \
  --skip-install

if [ $? -eq 0 ]; then
  echo -e "${GREEN}K3s config retrieved successfully!${NC}"
else
  echo -e "${RED}K3s config retrieval failed.${NC}"
fi

