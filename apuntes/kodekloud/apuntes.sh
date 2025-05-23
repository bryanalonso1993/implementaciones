#---------------------------------------
############# NETWORKING ###############
#---------------------------------------

# CNI
ps -aux | grep kubelet
ls /opt/cni/bin
ls /etc/cni/net.d

# Labels and Selectors
kubectl get pods -l 'env in (produccion), role in (frontend)'

controlplane ~ ➜  k get pods -l"env=prod,bu=finance,tier=frontend"
NAME          READY   STATUS    RESTARTS   AGE
app-1-zzxdf   1/1     Running   0          5m29s

kubectl get pods -l env=produccion, role=frontend

# contextos kubernetes
kubectl config current-context
kubectl config get-contexts

# check kubectlconfig for the new context
kubectl config view

# kube proxy
# ver el segmento de red configurado para kube-proxy
ps aux | grep kube-api-server
iptables -L -t nat | grep db-service
cat /var/log/kube-proxy.log

# localizar ip pods
cat /etc/cni/net.d/10-weave.conflist

# se observa el rango de ips 
controlplane ~ ➜  ps aux | grep -i weave
root        5834  0.0  0.0 746532 37712 ?        Ssl  21:39   0:01 /usr/bin/weave-npc
root        6050  0.0  0.0   1632  1156 ?        Ss   21:40   0:00 /bin/sh /home/weave/launch.sh
root        6155  0.0  0.0 3172760 47456 ?       Sl   21:40   0:01 /home/weave/weaver --port=6783 --datapath=datapath --name=4e:6f:46:71:53:f3 --http-addr=127.0.0.1:6784 --metrics-addr=0.0.0.0:6782 --docker-api= --no-dns --db-prefix=/weavedb/weave-net --ipalloc-range=10.244.0.0/16 --nickname=controlplane --ipalloc-init consensus=0 --conn-limit=200 --expect-npc --no-masq-local
root        6662  0.0  0.0 733728 24932 ?        Sl   21:40   0:00 /home/weave/kube-utils -run-reclaim-daemon -node-name=controlplane -peer-name=4e:6f:46:71:53:f3 -log-level=debug
root       11289  0.0  0.0   6744   656 pts/0    S+   22:34   0:00 grep --color=auto -i weave

# ip configurada para los servicios
controlplane ~ ➜  ps  aux  | grep kubelet
root        3672  0.0  0.1 1107364 320880 ?      Ssl  21:39   1:58 kube-apiserver --advertise-address=192.5.109.11 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
root        4666  0.0  0.0 3998236 97308 ?       Ssl  21:39   1:08 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9
root       11482  0.0  0.0   6744   724 pts/0    S+   22:36   0:00 grep --color=auto kubelet

# validar el tipo de seguridad usado por kube-proxy
kubectl  logs kube-proxy-5mvll -n kube-system
I0108 02:39:57.086196       1 node.go:141] Successfully retrieved node IP: 192.5.109.11
I0108 02:39:57.086290       1 server_others.go:110] "Detected node IP" address="192.5.109.11"
I0108 02:39:57.086334       1 server_others.go:551] "Using iptables proxy"
I0108 02:39:57.113334       1 server_others.go:190] "Using iptables Proxier"
I0108 02:39:57.113367       1 server_others.go:197] "kube-proxy running in dual-stack mode" ipFamily=IPv4
I0108 02:39:57.113374       1 server_others.go:198] "Creating dualStackProxier for iptables"
I0108 02:39:57.113397       1 server_others.go:481] "Detect-local-mode set to ClusterCIDR, but no IPv6 cluster CIDR defined, defaulting to no-op detect-local for IPv6"
I0108 02:39:57.113421       1 proxier.go:253] "Setting route_localnet=1 to allow node-ports on localhost; to change this either disable iptables.localhostNodePorts (--iptables-localhost-nodeports) or set nodePortAddresses (--nodeport-addresses) to filter loopback addresses"
I0108 02:39:57.182917       1 server.go:657] "Version info" version="v1.27.0"
I0108 02:39:57.182947       1 server.go:659] "Golang settings" GOGC="" GOMAXPROCS="" GOTRACEBACK=""
I0108 02:39:57.203571       1 conntrack.go:52] "Setting nf_conntrack_max" nfConntrackMax=1179648
I0108 02:39:57.205840       1 config.go:97] "Starting endpoint slice config controller"
I0108 02:39:57.205850       1 config.go:188] "Starting service config controller"
I0108 02:39:57.205887       1 config.go:315] "Starting node config controller"
I0108 02:39:57.205892       1 shared_informer.go:311] Waiting for caches to sync for service config
I0108 02:39:57.205893       1 shared_informer.go:311] Waiting for caches to sync for endpoint slice config
I0108 02:39:57.205898       1 shared_informer.go:311] Waiting for caches to sync for node config
I0108 02:39:57.306372       1 shared_informer.go:318] Caches are synced for endpoint slice config
I0108 02:39:57.306369       1 shared_informer.go:318] Caches are synced for service config
I0108 02:39:57.306407       1 shared_informer.go:318] Caches are synced for node config

# como esta deployado kube-proxy
controlplane ~ ➜  kubectl describe pod kube-proxy-5mvll -n kube-system | grep -i controlled
Controlled By:  DaemonSet/kube-proxy

# DNS Kubernetes
# Hostname | Namespace | Type | Root | IP Address
# web-service | apps | svc | cluster.local | 10.107.37.188
# 10-244-2-5 | apps | pod | cluster.local | 10.244.2.5

# PROBLEMAS CNI
kubeadm reset
systemctl stop kubelet
systemctl stop containerd
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down

# INGRESS CONTROLLER
# https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-ingress-em-
# https://kubernetes.io/docs/concepts/services-networking/ingress
# https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types

alias=k
export do="-o yaml --dry-run=client"


#----------------------------------------
############# ANNOTATIONS ###############
#----------------------------------------
kubectl annotate deployment -l app=airflow kubernetes.io/change-cause="Cambio global en Airflow" --overwrite -n platform-airflow-prod

kubectl annotate deployment -l app=airflow kubernetes.io/change-cause="Actualización imagen Airflow v1" --overwrite

MacBook-Pro-de-bryan:airflow bryanalonsoalmeydacontreras$ kubectl annotate deployment -l app=airflow kubernetes.io/change-cause="Actualización imagen Airflow v1" --overwrite
deployment.apps/airflow-scheduler annotated
deployment.apps/airflow-webserver annotated
deployment.apps/airflow-worker annotated

MacBook-Pro-de-bryan:airflow bryanalonsoalmeydacontreras$ kubectl rollout history deployment airflow-scheduler
deployment.apps/airflow-scheduler 
REVISION  CHANGE-CAUSE
1         Actualización imagen Airflow v1

#---------------------------------------------------
############# TAINTS AND TOLERATIONS ###############
#---------------------------------------------------

# Create a taint on node01 with key of spray, value of mortein and effect of NoSchedule

# Key = spray
# Value = mortein
# Effect = NoSchedule

controlplane ~ ➜  kubectl taint node node01 spray=mortein:NoSchedule
node/node01 tainted

controlplane ~ ➜  kubectl describe nodes node01 | grep -i taint
Taints:             spray=mortein:NoSchedule

#---------------------------------------------------
############# READINESSPROBE ###############
#---------------------------------------------------

apiVersion: v1 
kind: Pod 
metadata:
  labels: 
    name: simple-webapp 
  name: simple-webapp-2 
  namespace: default 
spec: 
  containers: 
  - env: 
    - name: APP_START_DELAY 
      value: "80" 
    image: kodekloud/webapp-delayed-start 
    imagePullPolicy: Always 
    name: simple-webapp
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
    ports: 
    - containerPort: 8080 
      protocol: TCP

##
controlplane ~ ➜  k get pods
NAME              READY   STATUS    RESTARTS   AGE
simple-webapp-1   1/1     Running   0          10m
simple-webapp-2   0/1     Running   0          46s

### READLINESSPROBE
---
apiVersion: v1 
kind: Pod 
metadata: 
  labels: 
    name: simple-webapp 
  name: simple-webapp-1 
  namespace: default 
spec: 
  containers: 
  - env: 
    - name: APP_START_DELAY 
      value: "80" 
    image: kodekloud/webapp-delayed-start 
    imagePullPolicy: Always 
    name: simple-webapp 
    livenessProbe:
      httpGet:
        path: /live
        port: 8080 
      initialDelaySeconds: 80
      periodSeconds: 1
    ports: 
    - containerPort: 8080 
      protocol: TCP
---
apiVersion: v1 
kind: Pod 
metadata:
  labels:
    name: simple-webapp
  name: simple-webapp-2
  namespace: default
spec:
  containers:
  - env:
    - name: APP_START_DELAY
      value: "80"
    image: kodekloud/webapp-delayed-start
    imagePullPolicy: Always
    name: simple-webapp
    livenessProbe:
      httpGet:
        path: /live
        port: 8080
      initialDelaySeconds: 80
      periodSeconds: 1
    ports:
    - containerPort: 8080
      protocol: TCP 

############################
# --- IMPERATIVE COMMANDS
############################

controlplane ~ ➜  kubectl  create service clusterip redis-service --tcp=6379:6379

controlplane ~ ➜  kubectl  create service clusterip redis-service --tcp=6379:6379 --dry-run=client -o yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: redis-service
  name: redis-service
spec:
  ports:
  - name: 6379-6379
    port: 6379
    protocol: TCP
    targetPort: 6379
  selector:
    app: redis-service
  type: ClusterIP
status:
  loadBalancer: {}

#### CREATE DEPLOYMENT
controlplane ~ ➜  k create deployment webapp --image=kodekloud/webapp-color --replicas=3 --dry-run=client -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: webapp
  name: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: webapp
    spec:
      containers:
      - image: kodekloud/webapp-color
        name: webapp-color
        resources: {}
status: {}

controlplane ~ ➜  k create deployment webapp --image=kodekloud/webapp-color --replicas=3 
deployment.apps/webapp created

controlplane ~ ➜  k create deployment redis-deploy --replicas=2 --image=redis  --namespace=dev-ns --dry-run=client -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: redis-deploy
  name: redis-deploy
  namespace: dev-ns
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis-deploy
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: redis-deploy
    spec:
      containers:
      - image: redis
        name: redis
        resources: {}
status: {}

controlplane ~ ➜  k create deployment redis-deploy --replicas=2 --image=redis  --namespace=dev-ns 
deployment.apps/redis-deploy created


kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml

#### Create a pod called httpd using the image httpd:alpine in the default namespace. Next, create a service of type ClusterIP by the same name (httpd). The target port for the service should be 80.

controlplane ~ ➜  k expose pod httpd --port=80 --name=httpd --type=ClusterIP --dry-run=client -o yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    run: httpd
  name: httpd
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    run: httpd
  type: ClusterIP
status:
  loadBalancer: {}

controlplane ~ ➜  k expose pod httpd --port=80 --name=httpd --type=ClusterIP 
service/httpd exposed