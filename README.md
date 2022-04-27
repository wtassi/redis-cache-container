# Redis-Cache-Docker

Redis Docker com TLS
> Nota: Necessário ter o Docker e Docker-compose configurado na maquina.

Link download Docker-Desktop: https://www.docker.com/products/docker-desktop/
- [Para Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)
- [Para Linux](https://hub.docker.com/search?q=&type=edition&offering=community&operating_system=linux&utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)
- [Para MAC com chip Intel](https://desktop.docker.com/mac/main/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)
- [Para MAC com chip Apple](https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module)

Por default, o path utilizado para gerar os certificados é: `./tls`, caso queira modificar, basta alterar nos arquivos ".ps1" ou ".sh".

Para buildar e executar o projeto, siga as etapas:

Primeiro gere os certificados SSL:

> Para Windows:
```powershell
  start .\gen-redis-certs.ps1
```
> Para Linux:
```shell
  sh .\gen-redis-certs.sh
```


Em seguida inicie o container do Redis

```
  docker-compose up -d
```

### Output

Host: 127.0.0.1

Porta: 6380

Password: redisTLS2022@@
