#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

#╔════════════════════════╗
#║   Ingress Controller   ║
#╚════════════════════════╝

# Note: NGINX Ingress needs ample time between: NGINX Ingress Controller creation, and when the Ingress object created.

# Reference : https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/baremetal/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.0/deploy/static/provider/baremetal/deploy.yaml
kubectl patch service --namespace ingress-nginx ingress-nginx-controller --patch '{"spec":{"externalTrafficPolicy":"Cluster","type":"NodePort","ports":[{"port":80,"nodePort":30080},{"port":443,"nodePort":30443}]}}'

Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --namespace ingress-nginx --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --namespace ingress-nginx -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --namespace ingress-nginx --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All NGINX Ingress pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All NGINX Ingress pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔══════════╗
#║   DVWA   ║
#╚══════════╝

# Source References:
# https://github.com/digininja/DVWA
# https://hub.docker.com/r/vulnerables/web-dvwa

# Initial Credential
# admin:password

# Credentials after initial reset
# admin:password
# gordonb:abc123
# 1337:charley
# pablo:letmein
# smithy:password

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: dvwa

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: dvwa
  namespace: dvwa
spec:
  selector:
    matchLabels:
      app: dvwa
  replicas: 1
  template:
    metadata:
      labels:
        app: dvwa
    spec:
      containers:
      - name: dvwa
        image: vulnerables/web-dvwa:1.9
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: dvwa
  name: dvwa
  namespace: dvwa
spec:
  ports:
  - nodePort: 30081
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: dvwa
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔══════════════╗
#║   Hackazon   ║
#╚══════════════╝

# Source Reference:
# https://github.com/cmutzel/all-in-one-hackazon
# https://hub.docker.com/r/bepsoccer/all-in-one-hackazon

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: hackazon

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hackazon
  namespace: hackazon
spec:
  selector:
    matchLabels:
      app: hackazon
  replicas: 1
  template:
    metadata:
      labels:
        app: hackazon
    spec:
      containers:
      - name: hackazon
        image: bepsoccer/all-in-one-hackazon
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: hackazon
  name: hackazon
  namespace: hackazon
spec:
  ports:
  - nodePort: 30082
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: hackazon
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

# Admin credential:
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if ( kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /hackazon-db-pw.txt ) ; then
  echo "Hackazon (UserID:eMail:Password) admin:admin@hackazon.com:$(kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /hackazon-db-pw.txt)"
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for Hackazon's configuration to be Completed."
  sleep $Loop_Period
 fi
done

# Correction to the 'sendmail' mail-agent which does not exist
kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /var/www/hackazon/assets/config/email.php
kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- sed -i "s/'type' *=> 'sendmail'/'type' => 'native'/g" /var/www/hackazon/assets/config/email.php
kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /var/www/hackazon/assets/config/email.php

#╔═════════════════╗
#║   HipsterShop   ║
#╚═════════════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: hipstershop

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: emailservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: emailservice
  replicas: 1
  template:
    metadata:
      labels:
        app: emailservice
    spec:
      terminationGracePeriodSeconds: 5
      containers:
      - name: server
        image: gcr.io/google-samples/microservices-demo/emailservice:v0.1.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
        env:
        - name: PORT
          value: "8080"
        readinessProbe:
          periodSeconds: 5
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:8080"]
        livenessProbe:
          periodSeconds: 5
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:8080"]
        env:
        - name: ENABLE_PROFILER
          value: "0"

---

apiVersion: v1
kind: Service
metadata:
  name: emailservice
  namespace: hipstershop
  labels:
    app: emailservice
spec:
  type: ClusterIP
  selector:
    app: emailservice
  ports:
  - name: grpc
    port: 5000
    targetPort: 8080

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: paymentservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: paymentservice
  replicas: 1
  template:
    metadata:
      labels:
        app: paymentservice
    spec:
      terminationGracePeriodSeconds: 5
      containers:
      - name: server
        image: gcr.io/google-samples/microservices-demo/paymentservice:v0.1.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 50051
        env:
        - name: PORT
          value: "50051"
        readinessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:50051"]
        livenessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:50051"]

---

apiVersion: v1
kind: Service
metadata:
  name: paymentservice
  namespace: hipstershop
  labels:
    app: paymentservice
spec:
  type: ClusterIP
  selector:
    app: paymentservice
  ports:
  - name: grpc
    port: 50051
    targetPort: 50051

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: productcatalogservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: productcatalogservice
  replicas: 1
  template:
    metadata:
      labels:
        app: productcatalogservice
    spec:
      terminationGracePeriodSeconds: 5
      containers:
      - name: server
        image: gcr.io/google-samples/microservices-demo/productcatalogservice:v0.1.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 3550
        env:
        - name: PORT
          value: "3550"
        readinessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:3550"]
        livenessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:3550"]

---

apiVersion: v1
kind: Service
metadata:
  name: productcatalogservice
  namespace: hipstershop
  labels:
    app: productcatalogservice
spec:
  type: ClusterIP
  selector:
    app: productcatalogservice
  ports:
  - name: grpc
    port: 3550
    targetPort: 3550

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: cartservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: cartservice
  replicas: 1
  template:
    metadata:
      labels:
        app: cartservice
    spec:
      terminationGracePeriodSeconds: 5
      containers:
      - name: server
        image: gcr.io/solutions-team-280017/cartservice:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 7070
        env:
        - name: REDIS_ADDR
          value: "redis-cart:6379"
        - name: PORT
          value: "7070"
        - name: LISTEN_ADDR
          value: "0.0.0.0"
        readinessProbe:
          initialDelaySeconds: 15
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:7070", "-rpc-timeout=5s"]
        livenessProbe:
          initialDelaySeconds: 15
          periodSeconds: 10
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:7070", "-rpc-timeout=5s"]

---

apiVersion: v1
kind: Service
metadata:
  name: cartservice
  namespace: hipstershop
  labels:
    app: cartservice
spec:
  type: ClusterIP
  selector:
    app: cartservice
  ports:
  - name: grpc
    port: 7070
    targetPort: 7070

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: currencyservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: currencyservice
  replicas: 1
  template:
    metadata:
      labels:
        app: currencyservice
    spec:
      terminationGracePeriodSeconds: 5
      containers:
      - name: server
        image: gcr.io/google-samples/microservices-demo/currencyservice:v0.1.2
        imagePullPolicy: IfNotPresent
        ports:
        - name: grpc
          containerPort: 7000
        env:
        - name: PORT
          value: "7000"
        readinessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:7000"]
        livenessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:7000"]

---

apiVersion: v1
kind: Service
metadata:
  name: currencyservice
  namespace: hipstershop
  labels:
    app: currencyservice
spec:
  type: ClusterIP
  selector:
    app: currencyservice
  ports:
  - name: grpc
    port: 7000
    targetPort: 7000

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: shippingservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: shippingservice
  replicas: 1
  template:
    metadata:
      labels:
        app: shippingservice
    spec:
      containers:
      - name: server
        image: gcr.io/google-samples/microservices-demo/shippingservice:v0.1.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 50051
        env:
        - name: PORT
          value: "50051"
        readinessProbe:
          periodSeconds: 5
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:50051"]
        livenessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:50051"]

---

apiVersion: v1
kind: Service
metadata:
  name: shippingservice
  namespace: hipstershop
  labels:
    app: shippingservice
spec:
  type: ClusterIP
  selector:
    app: shippingservice
  ports:
  - name: grpc
    port: 50051
    targetPort: 50051

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: recommendationservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: recommendationservice
  replicas: 1
  template:
    metadata:
      labels:
        app: recommendationservice
    spec:
      terminationGracePeriodSeconds: 5
      containers:
      - name: server
        image: gcr.io/google-samples/microservices-demo/recommendationservice:v0.1.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
        readinessProbe:
          periodSeconds: 5
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:8080"]
        livenessProbe:
          periodSeconds: 5
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:8080"]
        env:
        - name: PORT
          value: "8080"
        - name: PRODUCT_CATALOG_SERVICE_ADDR
          value: "productcatalogservice:3550"
        - name: ENABLE_PROFILER
          value: "0"

---

apiVersion: v1
kind: Service
metadata:
  name: recommendationservice
  namespace: hipstershop
  labels:
    app: recommendationservice
spec:
  ports:
  - name: grpc
    protocol: TCP
    port: 8089
    targetPort: 8080
  selector:
    app: recommendationservice

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: checkoutservice
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: checkoutservice
  replicas: 1
  template:
    metadata:
      labels:
        app: checkoutservice
    spec:
      containers:
      - name: server
        image: gcr.io/google-samples/microservices-demo/checkoutservice:v0.1.2
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 5050
        readinessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:5050"]
        livenessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:5050"]
        env:
        - name: PORT
          value: "5050"
        - name: PRODUCT_CATALOG_SERVICE_ADDR
          value: "productcatalogservice:3550"
        - name: SHIPPING_SERVICE_ADDR
          value: "shippingservice:50051"
        - name: PAYMENT_SERVICE_ADDR
          value: "paymentservice:50051"
        - name: EMAIL_SERVICE_ADDR
          value: "emailservice:5000"
        - name: CURRENCY_SERVICE_ADDR
          value: "currencyservice:7000"
        - name: CART_SERVICE_ADDR
          value: "cartservice:7070"

---

apiVersion: v1
kind: Service
metadata:
  name: checkoutservice
  namespace: hipstershop
  labels:
    app: checkoutservice
spec:
  type: ClusterIP
  selector:
    app: checkoutservice
  ports:
  - name: grpc
    port: 5050
    targetPort: 5050

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-cart
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: redis-cart
  replicas: 1
  template:
    metadata:
      labels:
        app: redis-cart
    spec:
      containers:
      - name: master
        image: k8s.gcr.io/redis:e2e   # or just image: redis
        imagePullPolicy: IfNotPresent
        resources:
          requests:
            cpu: 100m
            memory: 200Mi
        ports:
        - containerPort: 6379
        volumeMounts:
        - mountPath: /data
          name: redis-data
        resources:
          limits:
            memory: 256Mi
            cpu: 125m
          requests:
            cpu: 70m
            memory: 200Mi
      volumes:
      - name: redis-data
        emptyDir: {}

---

apiVersion: v1
kind: Service
metadata:
  name: redis-cart
  namespace: hipstershop
spec:
  type: ClusterIP
  selector:
    app: redis-cart
  ports:
  - name: redis
    port: 6379
    targetPort: 6379

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: loadgenerator
  namespace: hipstershop
spec:
  selector:
    matchLabels:
      app: loadgenerator
  replicas: 1
  template:
    metadata:
      labels:
        app: loadgenerator
      annotations:
        sidecar.istio.io/rewriteAppHTTPProbers: "true"
    spec:
      terminationGracePeriodSeconds: 5
      restartPolicy: Always
      containers:
      - name: main
        image: gcr.io/solutions-team-280017/load-generator:https
        imagePullPolicy: IfNotPresent
        env:
        - name: FRONTEND_ADDR
          value: "http://frontend:80"
        - name: USERS
          value: "10"
        resources:
          requests:
            cpu: 300m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: hipstershop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: server
        image: gcr.io/solutions-team-280017/hipster-frontend:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
        env:
        - name: PORT
          value: "8080"
        - name: PRODUCT_CATALOG_SERVICE_ADDR
          value: "productcatalogservice:3550"
        - name: CURRENCY_SERVICE_ADDR
          value: "currencyservice:7000"
        - name: CART_SERVICE_ADDR
          value: "cartservice:7070"
        - name: RECOMMENDATION_SERVICE_ADDR
          value: "recommendationservice:8089"
        - name: SHIPPING_SERVICE_ADDR
          value: "shippingservice:50051"
        - name: CHECKOUT_SERVICE_ADDR
          value: "checkoutservice:5050"
        - name: AD_SERVICE_ADDR
          value: "adservice:9555"

---

apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: hipstershop
  labels:
    app: frontend
    svc_name: frontend
spec:
  selector:
    app: frontend
  ports:
  - nodePort: 30083
    name: frontend
    port: 80
    targetPort: 8080
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔════════════════╗
#║   Juice-Shop   ║
#╚════════════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: juice-shop

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: juice-shop
  namespace: juice-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: juice-shop
  template:
    metadata:
      labels:
        app: juice-shop
    spec:
      containers:
      - name: juice-shop
        image: bkimminich/juice-shop:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 3000
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: juice-shop
  name: juice-shop
  namespace: juice-shop
spec:
  ports:
  - nodePort: 30084
    port: 80
    protocol: TCP
    targetPort: 3000
    name: http
  selector:
    app: juice-shop
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═════════════════╗
#║   F5-Demo-App   ║
#╚═════════════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: f5-demo-app

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-app
  namespace: f5-demo-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-app
  template:
    metadata:
      labels:
        app: f5-demo-app
    spec:
      containers:
      - name: f5-demo-app
        image: f5devcentral/f5-demo-app
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-app
  name: f5-demo-app
  namespace: f5-demo-app
spec:
  ports:
  - nodePort: 31081
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-app
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═══════════════════╗
#║   F5-Demo-HTTPD   ║
#╚═══════════════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: f5-demo-httpd

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-httpd-orange
  namespace: f5-demo-httpd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-httpd-orange
  template:
    metadata:
      labels:
        app: f5-demo-httpd-orange
    spec:
      containers:
      - name: f5-demo-httpd-orange
        image: f5devcentral/f5-demo-httpd:nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        env:
        - name: F5DEMO_APP
          value: website
        - name: F5DEMO_NODENAME
          value: "The Orange F5 Demo Application"
        - name: F5DEMO_COLOR
          value: ed7b0c
        - name: F5DEMO_NODENAME_SSL
          value: "The Orange SSL F5 Demo Application (SSL)"
        - name: F5DEMO_COLOR_SSL
          value: ed7b0c
        - name: F5DEMO_BACKEND_URL
          value: "http://f5-demo-httpd-green.f5-demo-httpd.svc.cluster.local/"

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-httpd-orange
  name: f5-demo-httpd-orange
  namespace: f5-demo-httpd
spec:
  ports:
  - nodePort: 31082
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-httpd-orange
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-httpd-green
  namespace: f5-demo-httpd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-httpd-green
  template:
    metadata:
      labels:
        app: f5-demo-httpd-green
    spec:
      containers:
      - name: f5-demo-httpd-green
        image: f5devcentral/f5-demo-httpd:nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        env:
        - name: F5DEMO_APP
          value: website
        - name: F5DEMO_NODENAME
          value: "The Green F5 Demo Application"
        - name: F5DEMO_COLOR
          value: a0bf37
        - name: F5DEMO_NODENAME_SSL
          value: "The Green SSL F5 Demo Application (SSL)"
        - name: F5DEMO_COLOR_SSL
          value: a0bf37
        - name: F5DEMO_BACKEND_URL
          value: "http://f5-demo-httpd-blue.f5-demo-httpd.svc.cluster.local/"

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-httpd-green
  name: f5-demo-httpd-green
  namespace: f5-demo-httpd
spec:
  ports:
  - nodePort: 31083
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-httpd-green
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-httpd-blue
  namespace: f5-demo-httpd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-httpd-blue
  template:
    metadata:
      labels:
        app: f5-demo-httpd-blue
    spec:
      containers:
      - name: f5-demo-httpd-blue
        image: f5devcentral/f5-demo-httpd:nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        env:
        - name: F5DEMO_APP
          value: website
        - name: F5DEMO_NODENAME
          value: "The Blue F5 Demo Application"
        - name: F5DEMO_COLOR
          value: 0194d2
        - name: F5DEMO_NODENAME_SSL
          value: "The Blue SSL F5 Demo Application (SSL)"
        - name: F5DEMO_COLOR_SSL
          value: 0194d2
        - name: F5DEMO_BACKEND_URL
          value: "http://f5-demo-httpd-orange.f5-demo-httpd.svc.cluster.local/"

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-httpd-blue
  name: f5-demo-httpd-blue
  namespace: f5-demo-httpd
spec:
  ports:
  - nodePort: 31084
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-httpd-blue
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔══════════╗
#║   Cafe   ║
#╚══════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: cafe

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
  namespace: cafe
spec:
  replicas: 2
  selector:
    matchLabels:
      app: coffee
  template:
    metadata:
      labels:
        app: coffee
    spec:
      containers:
      - name: coffee
        image: nginxdemos/nginx-hello:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: coffee
  namespace: cafe
spec:
  ports:
  - nodePort: 31085
    port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: coffee
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: milk
  namespace: cafe
spec:
  replicas: 2
  selector:
    matchLabels:
      app: milk
  template:
    metadata:
      labels:
        app: milk
    spec:
      containers:
      - name: milk
        image: nginxdemos/nginx-hello:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: milk
  namespace: cafe
spec:
  ports:
  - nodePort: 31086
    port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: milk
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
  namespace: cafe
spec:
  replicas: 2
  selector:
    matchLabels:
      app: tea
  template:
    metadata:
      labels:
        app: tea
    spec:
      containers:
      - name: tea
        image: nginxdemos/nginx-hello:plain-text
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: tea
  namespace: cafe
spec:
  ports:
  - nodePort: 31087
    port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: tea
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═════════════╗
#║   Arcadia   ║
#╚═════════════╝

# Arcadia needs to be executed last, since it needs NGINX Ingress.
# And NGINX Ingress needs ample time (in terms of scripting) between: NGINX Ingress Controller creation, and when the Ingress object created.

# This version of arcadia requires access as root path; i.e. it does NOT work when you configure accessing it as NOT root path.
# Example you configure access under http://domain.tld/arcadia/ (won't work) instead of http://domain.tld/ (what it needs).
# Returned HTML, CSS as well as JavaScript contains URL pointing to the root path.
# Changing the referenced URL in the returned HTML and/or CSS can be done.
# Changing the (code-formed) referenced URL inside OBFUSCATED JavaScript library requires reverse engineering and understanding of the JavaScripts' logic.

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: arcadia

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: arcadia-db
  namespace: arcadia
spec:
  replicas: 1
  selector:
    matchLabels:
      app: arcadia-db
  template:
    metadata:
      labels:
        app: arcadia-db
    spec:
      #config.nsm.nginx.com/ignore-incoming-ports: "27017" # This is used by NSM to not proxy the DB connection
      containers:
      - name: arcadia-db
        image: sorinboiaf5/arcadia-db:v0.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 27017

---

apiVersion: v1
kind: Service
metadata:
  name: arcadia-db
  namespace: arcadia
spec:
  ports:
  - port: 27017
    targetPort: 27017
    protocol: TCP
    name: mongo
  selector:
    app: arcadia-db

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: arcadia-frontend
  namespace: arcadia
spec:
  replicas: 1
  selector:
    matchLabels:
      app: arcadia-frontend
  template:
    metadata:
      labels:
        app: arcadia-frontend
    spec:
      containers:
      - name: arcadia-frontend
        image: sorinboiaf5/arcadia-frontend:v0.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: arcadia-frontend
  namespace: arcadia
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: arcadia-frontend

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: arcadia-login
  namespace: arcadia
spec:
  replicas: 1
  selector:
    matchLabels:
      app: arcadia-login
  template:
    metadata:
      labels:
        app: arcadia-login
    spec:
      containers:
      - name: arcadia-login
        image: sorinboiaf5/arcadia-login:v0.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: arcadia-login
  namespace: arcadia
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: arcadia-login

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: arcadia-stock-transaction
  namespace: arcadia
spec:
  replicas: 1
  selector:
    matchLabels:
      app: arcadia-stock-transaction
  template:
    metadata:
      labels:
        app: arcadia-stock-transaction
    spec:
      containers:
      - name: arcadia-stock-transaction
        image: sorinboiaf5/arcadia-stock_transaction:v0.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: arcadia-stock-transaction
  namespace: arcadia
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: arcadia-stock-transaction

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: arcadia-stocks
  namespace: arcadia
spec:
  replicas: 1
  selector:
    matchLabels:
      app: arcadia-stocks
  template:
    metadata:
      labels:
        app: arcadia-stocks
    spec:
      containers:
      - name: arcadia-stocks
        image: sorinboiaf5/arcadia-stocks:v0.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: arcadia-stocks
  namespace: arcadia
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: arcadia-stocks

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: arcadia-users
  namespace: arcadia
spec:
  replicas: 1
  selector:
    matchLabels:
      app: arcadia-users
  template:
    metadata:
      labels:
        app: arcadia-users
    spec:
      containers:
      - name: arcadia-users
        image: sorinboiaf5/arcadia-users:v0.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: arcadia-users
  namespace: arcadia
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: arcadia-users
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

kubectl exec -it -n arcadia $(kubectl get pods -n arcadia --no-headers=true | awk '{print $1}' | grep "main") -- ls -lap /var/www/html
kubectl exec -it -n arcadia $(kubectl get pods -n arcadia --no-headers=true | awk '{print $1}' | grep "main") -- mkdir --mode=777 --parents /var/www/html/contact
kubectl exec -it -n arcadia $(kubectl get pods -n arcadia --no-headers=true | awk '{print $1}' | grep "main") -- ls -lap /var/www/html

Loop_Period="9s"
until [ `kubectl get ingress --namespace arcadia --no-headers | grep -e "arcadia" | wc -l` -gt 0 ] ; do
kubectl apply -f - << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: arcadia
  namespace: arcadia
spec:
  ingressClassName: nginx
  defaultBackend:
    service:
      name: arcadia-frontend
      port:
        number: 80
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: arcadia-frontend
            port:
              number: 80
      - path: /v1/user
        pathType: Prefix
        backend:
          service:
            name: arcadia-users
            port:
              number: 80
      - path: /v1/login
        pathType: Prefix
        backend:
          service:
            name: arcadia-login
            port:
              number: 80
      - path: /v1/stock
        pathType: Prefix
        backend:
          service:
            name: arcadia-stocks
            port:
              number: 80
      - path: /v1/stockt
        pathType: Prefix
        backend:
          service:
            name: arcadia-stock-transaction
            port:
              number: 80
EOF
 if [ `kubectl get ingress --namespace arcadia --no-headers | grep -e "arcadia" | wc -l` -gt 0 ] ; then
  echo "`date +%Y%m%d%H%M%S` Ingress creation succeed."
 else
  echo "`date +%Y%m%d%H%M%S` Ingress creation failed. Wait and Repeat."
  sleep $Loop_Period
 fi
done

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

kubectl get node -o wide -A
kubectl get deployment -o wide -A
kubectl get pod -o wide -A
kubectl get service -o wide -A

#╔═════════╗
#║   End   ║
#╚═════════╝
