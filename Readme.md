# Redis-Docker

Redis Docker com TLS

Para buildar e executar o projeto

Primeiro gere os certificados SSL:

```
  start .\gen-redis-certs.ps1
```

Em seguida inicie o container do Redis

```
  docker-compose up -d
```

### Output

Host: 127.0.0.1
Porta: 6380
Password: redisTLS2022@@