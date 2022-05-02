# Serveur du projet ROK4 conteneurisés

Le serveur permet la diffusion des données conditionnées sous forme de pyramide raster ou vecteur selon les protocoles Web Map Service, Web Map Tiled Service et Tile Map Service

La documentation complète est disponible [ici](https://github.com/rok4/server), avec le code source.

## Lancement rapide

```
docker run --publish 9000:9000 rok4/rok4server:<VERSION>-<OS>
```

## Configuration personnalisée


Liste des variables d'environnement injectées dans les fichiers de configuration du serveur (et valeurs par défaut) :

* `server.json`
    * SERVER_LOGLEVEL (`error`)
    * SERVER_NBTHREAD (`4`)
    * SERVER_CACHE_SIZE (`1000`)
    * SERVER_CACHE_VALIDITY (`10`)

* `services.json`
    * SERVICE_TITLE (`WMS/WMTS/TMS server`)
    * SERVICE_ABSTRACT (`This server provide WMS, WMTS and TMS raster and vector data broadcast`)
    * SERVICE_PROVIDERNAME (`ROK4 Team`)
    * SERVICE_PROVIDERSITE (`https://github.com/rok4/documentation`)
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
    * SERVICE_WMS (`WMS service`)
    * SERVICE_MAXWIDTH (`10000`)
    * SERVICE_MAXHEIGHT (`10000`)
    * SERVICE_LAYERLIMIT (`2`)
    * SERVICE_MAXTILEX (`256`)
    * SERVICE_MAXTILEY (`256`)
    * SERVICE_FORMATLIST (`image/jpeg,image/png,image/tiff,image/geotiff,image/x-bil;bits=32`)
    * SERVICE_GLOBALCRSLIST (`CRS:84,EPSG:3857`)
    * SERVICE_FULLYSTYLING (`true`)
    * SERVICE_INSPIRE (`false`)
    * SERVICE_METADATAWMS_URL (``)
    * SERVICE_METADATAWMS_TYPE (``)
    * SERVICE_METADATAWMS_URL (``)
    * SERVICE_METADATAWMS_TYPE (``)
    * SERVICE_WMTSSUPPORT (`true`)
    * SERVICE_TMSSUPPORT (`true`)
    * SERVICE_WMSSUPPORT (`true`)
    * SERVICE_WMTS_ENDPOINT (`http://localhost/wmts`)
    * SERVICE_TMS_ENDPOINT (`http://localhost/tms`)
    * SERVICE_WMS_ENDPOINT (`http://localhost/wms`)


Il est possible de surcharger chacune de ces valeurs de configuration via des variables d'environnement. Exemple :

`docker run --publish 9000:9000 -e SERVICE_TITLE='"Mon serveur ROK4"' rok4/rok4server`

Afin de définir des valeurs avec des espaces (comme dans l'exemple), il faut bien encapsuler la chaîne avec des des doubles quotes et des simples.

Il est aussi possible de définir toutes les variables d'environnement dans un fichier (une variable par ligne) et de faire l'appel suivant :

`docker run --publish 9000:9000 --env-file=custom_env rok4/rok4server`

En définissant la variable d'environnement `IMPORT_LAYERS_FROM_PYRAMIDS` à une valeur non nulle, le script de lancement du serveur copie les fichiers avec l'extension `.lay.json` trouvés dans le dossier `/pyramids` dans le dossier `/layers` (en supprimant le .lay du nom).


## Lancement au sein d'une stack 

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
    image: rok4/server
    volumes:
      - volume-limadm:/pyramids/LIMADM
      - volume-alti:/pyramids/ALTI
      - volume-ortho:/pyramids/BDORTHO
      - volume-pente:/pyramids/PENTE
    environment:
      - IMPORT_LAYERS_FROM_PYRAMIDS=oui
      - SERVICE_WMTS_ENDPOINT=http://localhost/wmts
      - SERVICE_WMS_ENDPOINT=http://localhost/wms
      - SERVICE_TMS_ENDPOINT=http://localhost/tms
    depends_on:
      - data-limadm
      - data-alti
      - data-pente
      - data-ortho

  data-limadm:
    image: rok4/dataset:geofla-martinique
    volumes:
      - volume-limadm:/pyramids/LIMADM

  data-alti:
    image: rok4/dataset:bdalti-martinique
    volumes:
      - volume-alti:/pyramids/ALTI

  data-pente:
    image: rok4/dataset:pente-martinique
    volumes:
      - volume-pente:/pyramids/PENTE

  data-ortho:
    image: rok4/dataset:bdortho5m-martinique
    volumes:
      - volume-ortho:/pyramids/BDORTHO

volumes:
  volume-limadm:
  volume-alti:
  volume-ortho:
  volume-pente:

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
* Un serveur ROK4
* Des jeux de données, disponible sous forme d'[images](https://hub.docker.com/r/rok4/dataset)

Les capacités des 3 services rendus (WMS, WMTS et TMS) sont disponibles aux URL :

* WMS : http://localhost/wms?SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0
* WMTS : http://localhost/wmts?SERVICE=WMTS&REQUEST=GetCapabilities&VERSION=1.0.0
* TMS : http://localhost/tms/1.0.0

Une stack plus complète incluant un visualisateur est disponible [ici](https://github.com/rok4/docker/tree/master/run/server).
