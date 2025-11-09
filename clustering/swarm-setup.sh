#!/bin/bash
set -e

SERVICE_NAME="nginx-web"
REPLICAS=3
IMAGE_NAME="nginx:latest"
HOST_PORT=8080
CONTAINER_PORT=80

echo "🐳 Cleaning up old containers and network..."
docker rm -f manager worker1 worker2 2>/dev/null || true
docker network rm swarm-net 2>/dev/null || true

echo "🌐 Creating new network..."
docker network create --driver bridge swarm-net

echo "🚀 Starting manager and worker containers..."
# Manager
docker run -dit --name manager \
  --hostname manager \
  --privileged \
  --network swarm-net \
  -p ${HOST_PORT}:${HOST_PORT} \
  --restart unless-stopped docker:dind

# Workers
docker run -dit --name worker1 \
  --hostname worker1 \
  --privileged \
  --network swarm-net \
  --restart unless-stopped docker:dind

docker run -dit --name worker2 \
  --hostname worker2 \
  --privileged \
  --network swarm-net \
  --restart unless-stopped docker:dind

echo "⏳ Waiting for containers to initialize..."
sleep 10

MANAGER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' manager)
echo "🧠 Manager IP: $MANAGER_IP"

echo "🧩 Initializing Docker Swarm on manager..."
docker exec manager docker swarm init --advertise-addr $MANAGER_IP

WORKER_TOKEN=$(docker exec manager docker swarm join-token -q worker)
echo "🔑 Worker join token: $WORKER_TOKEN"

echo "👷 Joining workers to the swarm..."
docker exec worker1 docker swarm join --token $WORKER_TOKEN $MANAGER_IP:2377
docker exec worker2 docker swarm join --token $WORKER_TOKEN $MANAGER_IP:2377

echo "✅ Swarm cluster created successfully!"
docker exec manager docker node ls

echo "🚢 Deploying Nginx service: $SERVICE_NAME with $REPLICAS replicas..."
docker exec manager docker service create \
  --name $SERVICE_NAME \
  --replicas $REPLICAS \
  -p $HOST_PORT:$CONTAINER_PORT \
  $IMAGE_NAME

echo "🔍 Waiting for service to stabilize..."
sleep 10
docker exec manager docker service ps $SERVICE_NAME

echo
echo "🌐 Access the service from:"
echo "   👉 From WSL:    curl http://$MANAGER_IP:$HOST_PORT"
echo "   👉 From Windows: http://localhost:$HOST_PORT"
echo
echo "📜 Live logs (press Ctrl+C to stop):"
docker exec -it manager docker service logs -f $SERVICE_NAME