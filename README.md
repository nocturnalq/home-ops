# Home Ops Cluster

## Install k3s

Installing k3s using `k3sup`:
```
k3sup install --host 192.168.1.9 --ssh-port 1322 --user nocturnalq --ssh-key ~/.ssh/nocturnalq-server0 --k3s-channel latest --context home-server0 --k3s-extra-args '--flannel-backend=none --disable-kube-proxy=true disable-network-policy=true --cluster-init --disable traefik --disable servicelb --disable metrics-server'
```
