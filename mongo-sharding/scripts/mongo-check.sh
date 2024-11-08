#!/bin/bash

# Проверка общего количества документов в базе
docker compose exec -T mongos_router mongosh --port 27017 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

# Проверка на шардах 
docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

docker compose exec -T shard2 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF