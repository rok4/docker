# Outils de gestion du projet ROK4 conteneurisés

Cette suite d'outil facilite la gestion des pyramides (suppression, statistiques), la création de descripteur de couche par défaut, ainsi qu'un outil de conversion basé sur les TMS.

La documentation complète est disponible [ici](https://github.com/rok4/tools), avec le code source.

## CONVERT2JSON

Cet outil convertit un descripteur de pyramide de l'ancien format (XML, extension .pyr) vers le nouveau (JSON).

`docker run --rm -v /home/ign/descriptors:/descriptors rok4/tools convert2json.pl /descriptors/pyramid.pyr`

Le nouveau descripteur `pyramid.json` est écrit à côté de l'ancien.

## SUP-PYR

Cet outil supprime une pyramide à partir de son descripteur. Pour une pyramide stockée en fichier, il suffit de supprimer le dossier des données. Dans le cas de stockage objet, le fichier liste est parcouru et les dalles sont supprimées une par une.

Exemple de suppression d'une pyramide fichier :

```bash
docker run --rm \
    -v /home/ign/pyramids:/pyramids \
    rok4/tools \
    sup-pyr.pl --pyramid file:///pyramids/bdortho.json
```


Exemple de suppression d'une pyramide S3 :

```bash
docker run --rm \
    -e ROK4_S3_URL=https://s3.storage.com \
    -e ROK4_S3_KEY=key \
    -e ROK4_S3_SECRETKEY=secretkey \
    rok4/tools \
    sup-pyr.pl --pyramid s3:///bucket_name/pyramids/bdortho.json
```


## CREATE-LAYER

Cet outil génère un descripteur de couche pour le serveur ROK4 à partir du descripteur de pyramide et du dossier des TileMatrixSets. La couche utilisera alors la pyramide en entrée dans sa globalité.

```bash
docker run --rm \
    -e ROK4_S3_URL=https://s3.storage.com \
    -e ROK4_S3_KEY=key \
    -e ROK4_S3_SECRETKEY=secretkey \
    rok4/tools \
    create-layer.pl --title "Photographies aériennes" --pyramid s3:///bucket_name/pyramids/bdortho.json
```

## PYROLYSE

Cet outil génère un fichier JSON contenant, pour les dalles et les tuiles, DATA ou MASK, la taille totale, le nombre, la taille moyenne minimale et maximale, au global et par niveau. Les tailles sont en octet et les mesures sont faites sur les vraies données (listées dans le fichier liste). Pour des données vecteur, on ne compte que les tuiles de taille non nulle.

Stockages gérés pour l'analyse des dalles : FICHIER, CEPH, S3, SWIFT
Stockages gérés pour l'analyse des tuiles : FICHIER, SWIFT

```bash
docker run --rm \
    -e ROK4_S3_URL=https://s3.storage.com \
    -e ROK4_S3_KEY=key \
    -e ROK4_S3_SECRETKEY=secretkey \
    -v ./output:/output
    rok4/tools \
    pyrolyse.pl --pyramid s3:///bucket_name/pyramids/bdortho.json --json /output/stats.json --slabs ALL --tiles ALL --perfs /output/perfs.txt
```

## TMS-TOOLBOX

Ce outil permet de réaliser de nombreuses conversion entre indices de dalles, de tuiles, requêtes getTile ou getMap, liste de fichiers, géométrie WKT... grâce au TMS utilisé (ne nécessite pas de pyramide).

```bash
docker run --rm \
    -v ./input:/input
    rok4/tools \
    tms-toolbox.pl --tms PM --from GEOM_FILE:/input/geom.wkt --to SLAB_INDICES --level 15 --slabsize 16x16
```