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
docker compose exec -T shard11 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard11:27018" },
        { _id : 1, host : "shard12:27018" },
        { _id : 2, host : "shard13:27018" }
      ]
    }
);
EOF

docker compose exec -T shard21 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [       
        { _id : 0, host : "shard21:27018" },
        { _id : 1, host : "shard22:27018" },
        { _id : 2, host : "shard23:27018" }
      ]
    }
  );
EOF

# Инициализация роутера
docker compose exec -T mongos_router mongosh <<EOF

sh.addShard( "shard1/shard11:27018", "shard1/shard12:27018", "shard1/shard13:27018");
sh.addShard( "shard2/shard21:27018", "shard2/shard22:27018", "shard2/shard23:27018");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF

# Наполнение тестовыми данными
docker compose exec -T mongos_router mongosh <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
EOF