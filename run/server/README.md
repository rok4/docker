# Stacks de diffusion

Le serveur permet la diffusion des données conditionnées sous forme de pyramide raster ou vecteur selon les protocoles OGC Web Map Service, Web Map Tiled Service et API Tiles ou le protocole de l'OSGeo Tile Map Service.

La documentation complète est disponible [ici](https://rok4.github.io/server).

## Lancement rapide

```
docker run --publish 9000:9000 rok4/server:6.0.1
```

Ce serveur n'est pas interrogeable en HTTP mais en FastCGI, il faut donc avoir un serveur en amont pour faire la conversion (style NGinx).

## Configuration personnalisée

Liste des variables d'environnement injectées dans les fichiers de configuration du serveur (et valeurs par défaut) :

* `server.json`
	* SERVER_LOGLEVEL (`error`)
	* SERVER_LOGOUTPUT (`standard_output`)
	* SERVER_NBTHREAD (`4`)
	* SERVER_CACHE_SIZE (`1000`)
	* SERVER_CACHE_VALIDITY (`10`)
	* SERVER_LAYERS (`/etc/rok4/layers.txt`)
	* SERVER_STYLES (`/usr/share/rok4/styles`)
	* SERVER_TMS (`/usr/share/rok4/tilematrixsets`)
  * SERVER_BACKLOG (`0`)
* `services.json`
  * SERVICE_TITLE (`WMS/WMTS/TMS server`)
  * SERVICE_ABSTRACT (`This server provide WMS, WMTS and TMS raster and vector data broadcast`)
  * SERVICE_PROVIDERNAME (`ROK4 Team`)
  * SERVICE_PROVIDERSITE (`https://rok4.github.io/`)
  * SERVICE_KEYWORDS (`WMS,WMTS,TMS,Docker`)
  * SERVICE_FEE (`none`)
  * SERVICE_ACCESSCONSTRAINT (`none`)
  * SERVICE_INDIVIDUALNAME (``)
  * SERVICE_INDIVIDUALPOSITION (``)
  * SERVICE_VOICE (``)
  * SERVICE_FACSIMILE (``)
  * SERVICE_ADDRESSTYPE (``)
  * SERVICE_DELIVERYPOINT (``)
  * SERVICE_CITY (``)
  * SERVICE_ADMINISTRATIVEAREA (``)
  * SERVICE_POSTCODE (``)
  * SERVICE_COUNTRY (``)
  * SERVICE_ELECTRONICMAILADDRESS (``)
  * SERVICE_ADMIN_SUPPORT (`true`)
  * SERVICE_COMMON_SUPPORT (`true`)
  * SERVICE_COMMON_ENDPOINT (`http://localhost/common`)
  * SERVICE_WMTS_SUPPORT (`true`)
  * SERVICE_WMTS_ENDPOINT (`http://localhost/wmts`)
  * SERVICE_TMS_SUPPORT (`true`)
  * SERVICE_TMS_ENDPOINT (`http://localhost/tms`)
  * SERVICE_WMS_SUPPORT (`true`)
  * SERVICE_WMS_ENDPOINT (`http://localhost/wms`)
  * SERVICE_TILES_SUPPORT (`true`)
  * SERVICE_OGCTILES_ENDPOINT (`http://localhost/tiles`)


Il est possible de surcharger chacune de ces valeurs de configuration via des variables d'environnement. Exemple :

`docker run --publish 9000:9000 -e SERVICE_TITLE='"Mon serveur ROK4"' rok4/server`

Afin de définir des valeurs avec des espaces (comme dans l'exemple), il faut bien encapsuler la chaîne avec des des doubles quotes et des simples.

Il est aussi possible de définir toutes les variables d'environnement dans un fichier (une variable par ligne) et de faire l'appel suivant :

`docker run --publish 9000:9000 --env-file=custom_env rok4/server`

## Lancement au sein d'une stack avec stockage S3

Avec les fichiers :

* `docker-compose.yaml`
```yaml
version: "3"
services:
  front:
    image: nginx:alpine
    ports:
      - "80:80"
    links:
      - middle
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf

  middle:
    image: rok4/server:5.5.0
    depends_on:
      - storage
    environment:
      - SERVER_LOGLEVEL=info
      - SERVICE_WMTS_ENDPOINT=http://localhost:8082/data/wmts
      - SERVICE_WMS_ENDPOINT=http://localhost:8082/data/wms
      - SERVICE_TMS_ENDPOINT=http://localhost:8082/data/tms
      - SERVICE_COMMON_ENDPOINT=http://localhost:8082/data/common
      - SERVICE_TILES_ENDPOINT=http://localhost:8082/data/tiles
      - ROK4_S3_SECRETKEY=rok4S3storage
      - ROK4_S3_KEY=rok4
      - ROK4_S3_URL=http://storage:9000
      - SERVER_LAYERS=s3://layers/list.txt
      - SERVER_STYLES=s3://styles
      - SERVER_TMS=s3://tilematrixsets

  storage:
    image: rok4/dataset:minio
    command: server /data --console-address ":9001"
    ports:
      - "9000:9000"
      - "9001:9001"

```
* Fichier `nginx.conf` :
```
upstream server { server middle:9000; }
                                               
server {
    listen 80 default_server;

    location / {
        fastcgi_pass server;
        include fastcgi_params;
        add_header 'Access-Control-Allow-Origin' '*';
    }
}
```

Cette stack comprend :

* Un front NGINX, permettant l'interrogation du serveur en HTTP, avec une configuration minimale
* Des serveurs ROK4
* Un stockage S3, disponible sous forme d'[image](https://hub.docker.com/r/rok4/dataset), tag `minio`. Celui ci contient :
  * Les styles de base du projet
  * Les Tile Matrix Sets de base du projet
  * 5 pyramides sur la Martinique :
    * ALTI : données flottante, MNT à 25m
    * BDORTHO : photographies aériennes, à 5m
    * BDPARCELLAIRE : parcelles cadastrales, 50cm
    * PENTE : pente calculée à partir de la BDAlti à 25m
    * LIMADM : limites administratives au format vecteur
  * 5 descripteurs de couches
    * alti, avec le style hypso
    * bdortho
    * bdparcellaire, avec les styles orange et blanc
    * pente, avec le style montagne_palette
    * limadm

Cette centralisation du stockage permet plus facilement de déployer plusieurs middle : `docker-compose -f docker-compose.yaml up --scale middle=2`

Les capacités des 4 services rendus (WMS, WMTS, OGC API Tiles et TMS) sont disponibles aux URL :

* WMS : http://localhost/wms?SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0
* WMTS : http://localhost/wmts?SERVICE=WMTS&REQUEST=GetCapabilities&VERSION=1.0.0
* TMS : http://localhost/tms/1.0.0
* OGC API Tiles : http://localhost/tiles/collections

On peut retrouver ces informations sur la route de l'API Common : http://localhost/common

Des routes de santé permettent de surveiller l'activité et le contenu du serveur : 

* http://localhost/healthcheck
* http://localhost/healthcheck/info
* http://localhost/healthcheck/threads
* http://localhost/healthcheck/depends

Et les données sont consultables via l'interface du minio : http://localhost:9000 (accès : rok4 / rok4S3storage)

Une stack plus complète incluant un visualisateur est disponible [ici](https://github.com/rok4/docker/tree/master/run/server/docker-compose-s3.yaml).
