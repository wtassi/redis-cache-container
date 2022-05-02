# Redis-Cache-Docker

Redis Docker com TLS
> Nota: Necessário ter o Docker e Docker-compose configurado na maquina.

Link download Docker-Desktop: https://www.docker.com/products/docker-desktop/
- [Para Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)
- [Para Linux](https://hub.docker.com/search?q=&type=edition&offering=community&operating_system=linux&utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)
- [Para MAC com chip Intel](https://desktop.docker.com/mac/main/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)
- [Para MAC com chip Apple](https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)

## **_Senha do Redis_**

No arquivo "**redis.conf**" de cada tipo, possui o campo de configuração da senha de autenticação, o valor configurado por default é: **`redisTLS2022@@`**, altere no arquivo conforme desejado, se quiser tirar altenticação pasta comentar ou remover a linha "requirepass...".

## **_Redis com SSL_**
Para exeuctar o server do Redis com SSL, primeiro acesse o diretório "**`_local/redis_server_with_ssl`**" e em seguida execute o comando do docker-compose up

> Para Windows:
```powershell
  cd .\_local\redis_server_with_ssl
```
> Para Linux:
```shell
  sh ./_local/redis_server_with_ssl
```

Em seguida inicie o container do Redis

```
  docker-compose up -d
```

Para encerrar as aplicações:
```
  ctrl+c

  # ou

  docker-compose down

```

### Outputs

|      App     |    Host   |  Porta |      Credenciais      |
|--------------|-----------|--------|-----------------------|
| Redis Server | 127.0.0.1 |  6380  | Senha: redisTLS2022@@ |
| Redis UI     | 127.0.0.1 |   90   |  ---                  |


