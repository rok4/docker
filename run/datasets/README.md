# Stacks de génération

La génération complète se fait en utilisant les images `rok4/pregeneration`, `rok4/generation` et `rok4/tools`, disponibles sur [Docker Hub](https://hub.docker.com/r/rok4/)

## BE4

### Outil

* Options pour le choix des étapes de génération
    - `--pregeneration` : étape de génération des scripts
    - `--generation` : étape d'exécution des scripts
    - `--layer` : étape de génération du descripteur de couche
    - `--image` : étape de compilation de l'image de la pyramide
    - `--all` : les 4 étapes

* Options pour le choix du jeu de données
    - `--ortho`
    - `--alti`
    - `--pente`

### Jeux de données

| Image de données                    | Commande à lancer                                  | Dossier de pyramide |
| ----------------------------------- | -------------------------------------------------- | ------------------- |
| `rok4/dataset:bdortho5m-martinique` | `bash be4-generation.sh --all --ortho` | `pyramids/BDORTHO`  |
| `rok4/dataset:pente-martinique`     | `bash be4-generation.sh --all --alti`  | `pyramids/ALTI`     |
| `rok4/dataset:bdalti-martinique`    | `bash be4-generation.sh --all --pente` | `pyramids/PENTE`    |

## 4ALAMO

### Outil

* Options pour le choix des étapes de génération
    - `--pregeneration` : étape de génération des scripts
    - `--generation` : étape d'exécution des scripts
    - `--layer` : étape de génération du descripteur de couche
    - `--image` : étape de compilation de l'image de la pyramide
    - `--all` : les 4 étapes

* Options pour le choix du jeu de données
    - `--limadm`

### Jeux de données

| Image de données                 | Commande à lancer                                      | Dossier de pyramide |
| -------------------------------- | ------------------------------------------------------ | ------------------- |
| `rok4/dataset:geofla-martinique` | `bash 4alamo-generation.sh --all --limadm` | `pyramids/LIMADM`   |


## Tile Matrix Sets utilisé

* [PM](https://github.com/rok4/tilematrixsets/blob/master/PM.json)
* [UTM20W84MART_1M_MNT](https://github.com/rok4/tilematrixsets/blob/master/UTM20W84MART_1M_MNT.json)

## Détails sur les jeux de données

Jeux disponibles sous forme d'images Docker sur [Docker Hub](https://hub.docker.com/r/rok4/dataset)

### rok4/dataset:bdalti-martinique

1 pyramide, 1 couche

* Type : pyramide raster
    * Zone : Martinique
    * Tile Matrix Set : UTM20W84MART_1M_MNT
    * Niveau du bas : 6 (25m)
    * Source des données : [Alti (250m)](https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#bd-alti)

* Volume à monter : /pyramids/ALTI

* Exemple de requête à jouer pour ajouter la couche (avec Get Feature Info activé sur la valeur du pixel)

```bash
curl -X POST $ROK4SERVER_ENDPOINT/admin/layers/ALTI \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
   "wms" : {
      "authorized" : true,
      "crs" : [
         "IGNF:UTM20W84MART",
         "CRS:84",
         "IGNF:WGS84G",
         "EPSG:3857",
         "EPSG:4258",
         "EPSG:4326"
      ]
   },
   "tms" : {
      "authorized" : true
   },
   "keywords" : [
      "UTM20W84MART_1M_MNT",
      "RASTER"
   ],
   "wmts" : {
      "authorized" : true
   },
   "pyramids" : [
      {
         "top_level" : "0",
         "path" : "/pyramids/ALTI/ALTI.json",
         "bottom_level" : "6"
      }
   ],
   "title" : "ALTI",
   "resampling" : "nn",
   "abstract" : "Diffusion de la donnée ALTI.json",
   "styles" : [
      "normal",
      "hypso"
   ],
   "get_feature_info": {
      "type": "PYRAMID"
   }
}
EOF
```

### rok4/dataset:pente-martinique

1 pyramide, 1 couche

* Type : pyramide raster
    * Zone : Martinique
    * Tile Matrix Set : PM
    * Niveau du bas : 13 (20m)
    * Source des données : [Alti (250m)](https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#bd-alti)

* Volume à monter : /pyramids/PENTE

* Exemple de requête à jouer pour ajouter la couche

```bash
curl -X POST $ROK4SERVER_ENDPOINT/admin/layers/PENTE \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
   "wms" : {
      "authorized" : true,
      "crs" : [
         "EPSG:3857",
         "CRS:84",
         "IGNF:WGS84G",
         "EPSG:3857",
         "EPSG:4258",
         "EPSG:4326"
      ]
   },
   "abstract" : "Diffusion de la donnée PENTE.json",
   "title" : "PENTE",
   "pyramids" : [
      {
         "bottom_level" : "13",
         "path" : "/pyramids/PENTE/PENTE.json",
         "top_level" : "0"
      }
   ],
   "styles" : [
      "normal"
   ],
   "tms" : {
      "authorized" : true
   },
   "wmts" : {
      "authorized" : true
   },
   "keywords" : [
      "PM",
      "RASTER"
   ]
}
EOF
```

### rok4/dataset:bdortho5m-martinique

1 pyramides, 1 couches

* Type : pyramide raster
    * Zone : Martinique
    * Tile Matrix Set : PM
    * Niveau du bas : 15 (7m)
    * Source des données : [BDOrtho (5m)](https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#bd-ortho-5-m)

* Volume à monter : /pyramids/BDORTHO

* Exemple de requête à jouer pour ajouter la couche

```bash
curl -X POST $ROK4SERVER_ENDPOINT/admin/layers/BDORTHO \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
   "title" : "BDORTHO",
   "abstract" : "Diffusion de la donnée BDORTHO.json",
   "wmts" : {
      "authorized" : true
   },
   "keywords" : [
      "PM",
      "RASTER"
   ],
   "tms" : {
      "authorized" : true
   },
   "styles" : [
      "normal"
   ],
   "pyramids" : [
      {
         "path" : "/pyramids/BDORTHO/BDORTHO.json",
         "top_level" : "0",
         "bottom_level" : "15"
      }
   ],
   "wms" : {
      "crs" : [
         "EPSG:3857",
         "CRS:84",
         "IGNF:WGS84G",
         "EPSG:3857",
         "EPSG:4258",
         "EPSG:4326"
      ],
      "authorized" : true
   }
}
EOF
```

### rok4/dataset:geofla-martinique

1 pyramide, 1 couche

* Type : pyramide vecteur
    * Zone : Martinique
    * Tile Matrix Set : PM
    * Niveau du bas : 18
    * Source des données : [GEOFLA](https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#geofla)

* Volume à monter : /pyramids/LIMADM

* Exemple de requête à jouer pour ajouter la couche

```bash
curl -X POST $ROK4SERVER_ENDPOINT/admin/layers/LIMADM \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
   "tms" : {
      "authorized" : true
   },
   "keywords" : [
      "PM",
      "RASTER"
   ],
   "abstract" : "Diffusion de la donnée LIMADM.json",
   "title" : "LIMADM",
   "pyramids" : [
      {
         "top_level" : "0",
         "path" : "/pyramids/LIMADM/LIMADM.json",
         "bottom_level" : "18"
      }
   ]
}
EOF
```

### rok4/dataset:minio

Cette image, ayant pour base `minio/minio`, est un styockage S3 contenant les styles, les tile matrix sets, les pyramides et les descripteurs de couche. Ce stockage centralisé permet d'exploiter le fonctionnement du serveur ROK4 5.0.0.

Ce stockage se lance via la commande `docker run -p 9000:9000 -p 9001:9001 rok4/dataset:minio` et une interface graphique de gestion est disponible à l'URL `http://localhost:9001/buckets` (accès : rok4 / rok4S3storage)

Ce stockage contient les buckets suivants :

* `styles` : tous les styles du projet ROK4
* `tilematrixsets` : tous les tile matrix sets du projet ROK4
* `pyramids` : les pyramides BDORTHO, ALTI, PENTE et LIMADM
* `layers` : l'objet liste `list.txt` et les descripteurs de couche BDORTHO, ALTI, PENTE et LIMADM