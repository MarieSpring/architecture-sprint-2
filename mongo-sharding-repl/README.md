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

Выполняем проверку

```shell
./scripts/mongo-check.sh
```