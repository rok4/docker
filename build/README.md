# Compilation des images applicatives

L'installation des applicatifs s'appuie sur les paquets debian disponibles au niveau des releases sur GitHub.

Dans le cas de présence d'un proxy, ajouter les arguments `--build-arg http_proxy=http://votre.proxy.fr:1234 --build-arg https_proxy=http://votre.proxy.fr:1234`.

Les styles et les Tile Matrix Sets sont par défaut ceux de la version 4.0. Il espossible de changer cela en précisant les arguments `ROK4TILEMATRIXSETS_VERSION` et `ROK4STYLES_VERSION` :

* https://github.com/rok4/tilematrixsets/releases
* https://github.com/rok4/styles/releases

## Compilation de l'image de pré-génération

Versions applicatives disponibles : https://github.com/rok4/pregeneration/releases

`docker build -t rok4/pregeneration:TAG --build-arg ROK4PREGENERATION_VERSION=TAG --build-arg ROK4COREPERL_VERSION=TAG -f pregeneration/debian11.Dockerfile  pregeneration/`

## Compilation de l'image de génération

Versions applicatives disponibles : https://github.com/rok4/generation/releases

`docker build -t rok4/generation:TAG --build-arg ROK4GENERATION_VERSION=TAG -f generation/debian11.Dockerfile  generation/`

## Compilation de l'image des outils de gestion

Versions applicatives disponibles : https://github.com/rok4/tools/releases

`docker build -t rok4/tools:TAG --build-arg ROK4TOOLS_VERSION=TAG --build-arg ROK4COREPERL_VERSION=TAG -f tools/debian11.Dockerfile  tools/`

## Compilation de l'image compète de génération

`docker build -t rok4/fullgeneration:TAG --build-arg ROK4PREGENERATION_VERSION=TAG --build-arg ROK4COREPERL_VERSION=TAG --build-arg ROK4GENERATION_VERSION=TAG --build-arg ROK4TOOLS_VERSION=TAG -f fullgeneration/debian11.Dockerfile fullgeneration/`

## Compilation de l'image du serveur de diffusion

Versions applicatives disponibles : https://github.com/rok4/server/releases

`docker build -t rok4/server:TAG --build-arg ROK4SERVER_VERSION=TAG -f server/debian11.Dockerfile server/`
