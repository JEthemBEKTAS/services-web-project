# Services Web Project

## 1. Prérequis
- Docker & docker login
- Kubernetes (k3s/microk8s/kind…)
- kubectl configuré

## 2. Construction des images
### MariaDB
\`\`\`bash
docker build --network=host -t test-mariadb docker/mariadb/
docker tag test-mariadb docker.io/USERNAME/mariadb:latest
docker push docker.io/USERNAME/mariadb:latest
\`\`\`

### WordPress
\`\`\`bash
docker build --network=host -t test-wordpress docker/wordpress/
docker tag test-wordpress docker.io/USERNAME/wordpress:latest
docker push docker.io/USERNAME/wordpress:latest
\`\`\`

### Nginx
\`\`\`bash
docker build -t test-nginx docker/nginx/
docker tag test-nginx docker.io/USERNAME/nginx:latest
docker push docker.io/USERNAME/nginx:latest
\`\`\`

## 3. Déploiement Kubernetes
1. Appliquer les secrets d’exemple (à adapter en prod) :
   \`\`\`bash
   kubectl apply -f k8s/examples/
   \`\`\`
2. Appliquer la ConfigMap, PVC, déploiements et services :
   \`\`\`bash
   kubectl apply -f k8s/nginx-config.yaml
   kubectl apply -f k8s/mariadb-pvc.yaml
   kubectl apply -f k8s/mariadb-deployment.yaml
   kubectl apply -f k8s/wordpress-deployment.yaml
   kubectl apply -f k8s/nginx-deployment.yaml
   kubectl apply -f k8s/nginx-service.yaml
   \`\`\`

## 4. Vérifications
\`\`\`bash
kubectl get pods,svc,pvc
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "$NODE_IP my.test.local" | sudo tee -a /etc/hosts
curl -kI http://my.test.local:30080
curl -kI https://my.test.local:30443
\`\`\`

