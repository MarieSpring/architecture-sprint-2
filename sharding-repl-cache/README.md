# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Конфигурируем mongodb и заполняем данными

```shell
./scripts/mongo-init.sh
```

Создаем кластер redis
```shell
docker compose exec -T redis1 sh
echo "yes" | redis-cli --cluster create 173.17.0.2:6379 173.17.0.3:6379 173.17.0.4:6379 173.17.0.5:6379 173.17.0.6:6379 173.17.0.7:6379 --cluster-replicas 1
```

или 
```shell
./scripts/redis-init.sh
```

Выполняем проверку

```shell
./scripts/mongo-check.sh
```

GET http://localhost:8080/helloDoc/users