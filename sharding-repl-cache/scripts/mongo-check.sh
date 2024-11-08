#!/bin/bash

# Проверка общего количества документов в базе
docker compose exec -T mongos_router mongosh --port 27017 <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

# Проверка на шардах и статуса реплик
docker compose exec -T shard11 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();

rs.status();
EOF

docker compose exec -T shard21 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();

rs.status();
EOF