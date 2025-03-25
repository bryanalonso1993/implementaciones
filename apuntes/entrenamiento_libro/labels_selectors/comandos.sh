bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get pods 
NAME                   READY   STATUS    RESTARTS   AGE
pilot-dev-memcached    1/1     Running   0          22s
pilot-dev-nginx        1/1     Running   0          22s
pilot-prod-memcached   1/1     Running   0          6s
pilot-prod-nginx       1/1     Running   0          19s

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get pods 
NAME                   READY   STATUS    RESTARTS   AGE
pilot-dev-memcached    1/1     Running   0          22s
pilot-dev-nginx        1/1     Running   0          22s
pilot-prod-memcached   1/1     Running   0          6s
pilot-prod-nginx       1/1     Running   0          19s

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get pods -l "environment=production"
NAME                   READY   STATUS    RESTARTS   AGE
pilot-prod-memcached   1/1     Running   0          35s
pilot-prod-nginx       1/1     Running   0          48s

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get pods -l "environment=develop"   
NAME                  READY   STATUS    RESTARTS   AGE
pilot-dev-memcached   1/1     Running   0          57s
pilot-dev-nginx       1/1     Running   0          57s

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get pods -l"environment=production,tier=frontend"
NAME               READY   STATUS    RESTARTS   AGE
pilot-prod-nginx   1/1     Running   0          2m12s

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get pods -l"environment!=production,tier=frontend"
NAME              READY   STATUS    RESTARTS   AGE
pilot-dev-nginx   1/1     Running   0          3m23s

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get pods -l"environment in (production), tier notin (frontend)" 
NAME                   READY   STATUS    RESTARTS   AGE
pilot-prod-memcached   1/1     Running   0          4m32s

# Crear servicio - con selector
bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl apply -f pilot-nginx-service.yaml
service/pilot-nginx-svc created

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl get svc   
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes        ClusterIP   10.96.0.1        <none>        443/TCP        40d
pilot-nginx-svc   NodePort    10.101.121.102   <none>        80:30452/TCP   5s

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl delete -f pilot-nginx-service.yaml 
service "pilot-nginx-svc" deleted

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl delete -f pilot-prod.yaml 
pod "pilot-prod-nginx" deleted
pod "pilot-prod-memcached" deleted

bryanalonso@MacBook-Pro-de-bryan labels_selectors % kubectl delete -f pilot-dev.yaml 
pod "pilot-dev-nginx" deleted
pod "pilot-dev-memcached" deleted
