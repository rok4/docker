# Utilisation du serveur ROK4 conteneurisé

Serveur WMS, WMTS et TMS issu du projet [ROK4](https://github.com/rok4/rok4)

- [Lancement rapide](#lancement-rapide)
- [Configuration personnalisée](#configuration-personnalisée)
- [Lancement au sein d'une stack](#lancement-au-sein-dune-stack)

## Lancement rapide

```
docker run --publish 9000:9000 rok4/rok4server:<VERSION>-<OS>
```

## Configuration personnalisée

Vous pouvez voir les valeurs par défaut se retrouvant dans les deux fichiers de compilation des images docker du serveur ROK4 (https://github.com/rok4/rok4/blob/master/docker/rok4server/debian11.Dockerfile).

Il est possible de surcharger chacune de ces valeurs de configuration via des variables d'environnement. Exemple :

`docker run --publish 9000:9000 -e SERVICE_TITLE='"Mon serveur ROK4"' rok4/rok4server:<VERSION>-<OS>`

Afin de définir des valeurs avec des espaces (comme dans l'exemple), il faut bien encapsuler la chaîne avec des des doubles quotes et des simples.

Il est aussi possible de définir toutes les variables d'environnement dans un fichier (une variable par ligne) et de faire l'appel suivant :

`docker run --publish 9000:9000 --env-file=custom_env rok4/rok4server:<VERSION>-<OS>`

En définissant la variable d'environnement `IMPORT_LAYERS_FROM_PYRAMIDS` à une valeur non nulle, le script de lancement du serveur copie les fichiers avec l'extension `.lay.json` trouvés dans le dossier `/pyramids` dans le dossier `/layers` (en supprimant le .lay du nom).

Liste des variables d'environnement injectées dans les fichiers de configuration du serveur :

* `server.json`
    * SERVER_LOGLEVEL
    * SERVER_NBTHREAD
    * SERVER_CACHE_SIZE
    * SERVER_CACHE_VALIDITY

* `services.json`
    * SERVICE_TITLE
    * SERVICE_ABSTRACT
    * SERVICE_PROVIDERNAME
    * SERVICE_PROVIDERSITE
    * SERVICE_KEYWORDS
    * SERVICE_FEE
    * SERVICE_ACCESSCONSTRAINT
    * SERVICE_INDIVIDUALNAME
    * SERVICE_INDIVIDUALPOSITION
    * SERVICE_VOICE
    * SERVICE_FACSIMILE
    * SERVICE_ADDRESSTYPE
    * SERVICE_DELIVERYPOINT
    * SERVICE_CITY
    * SERVICE_ADMINISTRATIVEAREA
    * SERVICE_POSTCODE
    * SERVICE_COUNTRY
    * SERVICE_ELECTRONICMAILADDRESS
    * SERVICE_WMS
    * SERVICE_MAXWIDTH
    * SERVICE_MAXHEIGHT
    * SERVICE_LAYERLIMIT
    * SERVICE_MAXTILEX
    * SERVICE_MAXTILEY
    * SERVICE_FORMATLIST
    * SERVICE_GLOBALCRSLIST
    * SERVICE_FULLYSTYLING
    * SERVICE_INSPIRE
    * SERVICE_METADATAWMS_URL
    * SERVICE_METADATAWMS_TYPE
    * SERVICE_METADATAWMS_URL
    * SERVICE_METADATAWMS_TYPE
    * SERVICE_WMTSSUPPORT
    * SERVICE_TMSSUPPORT
    * SERVICE_WMSSUPPORT
    * SERVICE_WMTS_ENDPOINT
    * SERVICE_TMS_ENDPOINT
    * SERVICE_WMS_ENDPOINT

## Lancement au sein d'une stack 

Afin de tester facilement le serveur, il est possible de lancer une stack comprennant :

* Un front NGINX, permettant l'interrogation du serveur en HTTP, avec une configuration minimale
* Un serveur ROK4
* Des jeux de données, disponible sous forme d'[images](https://hub.docker.com/r/rok4/dataset)

En étant dans ce dossier, vous pouvez lancer la stack via la commande `TAG=<VERSION> docker-compose up`.

Les capacités des 3 services rendus (WMS, WMTS et TMS) sont disponibles aux URL :

* WMS : http://localhost:8082/data/wms?SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0
* WMTS : http://localhost:8082/data/wmts?SERVICE=WMTS&REQUEST=GetCapabilities&VERSION=1.0.0
* TMS : http://localhost:8082/data/tms/1.0.0

Un viewer est disponible à l'URL http://localhost:8082/viewer