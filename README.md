# Home Ops Cluster

## Install k3s

Installing k3s using `k3sup`:

```
k3sup install --host 192.168.1.9 --ssh-port 1322 --user nocturnalq --ssh-key ~/.ssh/nocturnalq-server0 --k3s-channel latest --context home-server0
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

flux create secret git flux-system \
  --url=https://github.com/nocturnalq/home-ops.git \
  --username=nocturnalq \
  --password=$GITHUB_TOKEN

kubectl apply -n flux-system -f clusters/home/bootstrap.yaml
```
