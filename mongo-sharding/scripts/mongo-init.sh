#!/bin/bash

# Инициализация конфигурационный сервер
docker compose exec -T configSrv mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27019" }
    ]
  }
);
EOF

# Инициализация шардов
docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" }
      ]
    }
);
EOF

docker compose exec -T shard2 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [       
        { _id : 1, host : "shard2:27018" }
      ]
    }
  );
EOF

# Инициализация роутера
docker compose exec -T mongos_router mongosh <<EOF

sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27018");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF

# Наполнение тестовыми данными
docker compose exec -T mongos_router mongosh <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
EOF