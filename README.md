# Docker-compose

### デプロイ後に作られるリソース
- nginx
- php-fpm
- redis
- mysql


### デプロイ

```
$sudo docker-compose build --no-cache
```

### 起動手順

```
$ sudo docker-compose up d
```
### コンテナにログイン(alpineのため)

```
$ sudo docker-compose exec php-fpm /bin/ash
```
