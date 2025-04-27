# Home Ops Cluster

## Install k3s

Installing k3s using `k3sup`:

```
k3sup install --host 192.168.1.9 --ssh-port 1322 --user nocturnalq --ssh-key ~/.ssh/nocturnalq-server0 --k3s-channel latest --context home-server0 --k3s-extra-args="--flannel-backend=none --disable-network-policy"
```

## Install Cilium

```
helm install cilium cilium/cilium --version 1.17.3 --namespace kube-system --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" --set operator.replicas=1 --set kubeProxyReplacement=true --set ipam.mode=kubernetes --set k8sServiceHost=192.168.1.9 --set k8sServicePort=6443 --set rollOutCiliumPods=true --set operator.rollOutPods=true
```

## Restart pods which not managed by cilium

```
kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTNETWORK:.spec.hostNetwork --no-headers=true | grep '<none>' | awk '{print "-n "$1" "$2}' | xargs -L 1 -r kubectl delete pod
```

## Create nginx deployment for testing

```
cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: default
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: basic-ingress
  namespace: default
spec:
  ingressClassName: traefik
  rules:
  - http:
      paths:
      - backend:
          service:
            name: nginx
            port:
              number: 80
        path: /
        pathType: Prefix
EOF
```

## Install Flux Operator

```
helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
  --namespace flux-system \
  --create-namespace

flux create secret git flux-system --url=ssh://git@github.com/nocturnalq/home-ops --private-key-file=./github

kubectl apply -n flux-system -f clusters/home/bootstrap.yaml
```

## Fix DNS Issue on Debian 10

```
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
```

## Fix DNS Issue On Ubuntu 24.10

```
sudo nano /etc/systemd/resolved.conf
[Resolve]
   DNSStubListenerExtra=0.0.0.0

sudo systemctl restart systemd-resolved

sudo systemctl disable apparmor
sudo systemctl stop apparmor
```
