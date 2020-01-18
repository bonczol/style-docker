# style-docker
## Budowanie :snail:
$ docker build -t style .

## Uruchamianie
$ docker run -it --gpus all style

## Konfiguracja kontenera
$ docker pull kamieen03/style-transfer:latest
$ docker run -it --gpus all --name=temp_style kamieen03/style-transfer:latest
$ exit
$ docker commit temp_style kamieen03/style-transfer
$ docker run -it --gpus all kamieen03/style-transfer:latest
