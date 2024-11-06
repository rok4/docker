# Outils python de gestion du projet ROK4 conteneurisés

Cette suite d'outil facilite la gestion des pyramides (conversions, statistiques), la création de descripteur de couche par défaut, ainsi qu'un outil de conversion basé sur les TMS.

La documentation complète est disponible [ici](https://rok4.github.io/pytools).

## PYR2PYR

PYR2PYR est un outil de copie d'une pyramide d'un stockage à un autre. Il est possible de filtrer les dalles transférée en précisant une taille limite sous laquelle les données ne sont pas recopiées. La copie des dalles est parallélisable. Si des signatures MD5 sont présente dans le fichier liste, elles sont contrôlées après recopie.

Un exemple de configuration est affichable avec la commande `pyr2pyr --role example` et l'appel `pyr2pyr --role check --conf conf.json` permet de valider un fichier de configuration. Le fichier de configuration peut être un objet, auquel cas le chemin doit être préfixé par le type de stockage (exemple : `s3://bucket/configuration.json`)

Exemple d'appel :

```bash
docker run --rm \
    -e ROK4_S3_SECRETKEY=rok4S3storage \
    -e ROK4_S3_KEY=rok4 \
    -e ROK4_S3_URL=http://storage:9000 \
    -v ./input:/input
    rok4/tools \
    rok4/pytools \
    pyr2pyr --role master --conf s3://configurations/pyr2pyr.json
```

Documentation complète de l'outil [ici](https://rok4.github.io/pytools/latest/#pyr2pyr).

### JOINCACHE

L'outil JOINCACHE génèrent une pyramide raster à partir d'autres pyramide raster compatibles (même TMS, dalles de même dimensions, canaux au même format). La composition se fait verticalement (choix des pyramides sources par niveau) et horizontalement (choix des pyramides source par zone au sein d'un niveau).

Un exemple de configuration est affichable avec la commande `joincache --role example` et l'appel `joincache --role check --conf conf.json` permet de valider un fichier de configuration. Le fichier de configuration peut être un objet, auquel cas le chemin doit être préfixé par le type de stockage (exemple : `s3://bucket/configuration.json`)

Exemple d'appel :

```bash
docker run --rm \
    -e ROK4_S3_SECRETKEY=rok4S3storage \
    -e ROK4_S3_KEY=rok4 \
    -e ROK4_S3_URL=http://storage:9000 \
    rok4/pytools \
    joincache --role agent --split 1 --conf s3://configurations/joincache.json
```

Documentation complète de l'outil [ici](https://rok4.github.io/pytools/latest/#joincache).

### MAKE-LAYER

MAKE-LAYER est un outil générant un descripteur de couche compatible avec le serveur à partir des pyramides de données à utiliser

Exemple d'appel :

```bash
docker run --rm \
    -e ROK4_S3_SECRETKEY=rok4S3storage \
    -e ROK4_S3_KEY=rok4 \
    -e ROK4_S3_URL=http://storage:9000 \
    rok4/pytools \
    make-layer --pyramids s3://pyramids/data.json --name my_data --title "Titre de ma couche" --directory s3://layers/
```

Documentation complète de l'outil [ici](https://rok4.github.io/pytools/latest/#make-layer).

### PYROLYSE

PYROLYSE est un outil d'analyse d'une pyramide, permettant d'avoir le nombre et la taille des dalles et tuiles, au global et par niveau. Les tailles des dalles et des tuiles ne sont pas toutes récupérées : un ratio permet de définir le nombre de mesures (un ratio de 100 entraînera la récupération de la taille d'une dalle sur 100 et d'une de ses tuile). Ce ratio s'applique par niveau (pour ne pas avoir que des données sur le meilleur niveau, celui qui contient le plus de dalles). Lorsque les statistiques sur les tuiles sont activées, on mesure le temps de lecture du header.

Concernant les tailles et les temps d'accès, il est possible de demander le calcul des déciles plutôt que de garder toutes les valeurs.

Exemple d'appel :

```bash
docker run --rm \
    -e ROK4_S3_SECRETKEY=rok4S3storage \
    -e ROK4_S3_KEY=rok4 \
    -e ROK4_S3_URL=http://storage:9000 \
    -v $PWD/output:/output \
    rok4/pytools \
    pyrolyse --pyramid s3://pyramids/data.json --tiles --progress --ratio 10 --json /output/stats.json
```

Documentation complète de l'outil [ici](https://rok4.github.io/pytools/latest/#pyrolyse).

### TMSIZER

TMSIZER est un outil permettant de convertir des informations selon différents formats en accord avec un Tile Matrix Set en particulier. Les données en entrée peuvent être lues depuis un fichier, un objet ou l'entrée standard. Les données en sortie peuvent être écrites dans un fichier, un objet ou la sortie standard.

Exemples d'appel :

```bash
docker run --rm \
    -v $PWD/input:/input:ro \
    -v $PWD/output:/output \
    rok4/pytools \
    tmsizer -i /input/logs.txt --tms PM -io levels=15,14 -io layers=LAYER.NAME1,LAYER.NAME2,LAYER.NAME3 -if GETTILE_PARAMS -of HEATMAP -oo bbox=65000,6100000,665000,6500000 -oo dimensions=600x400 -o /output/heatmap.tif
```

Avec utilisation des aires prédéfinie et calage sur un niveau :

```bash
docker run --rm \
    -v $PWD/input:/input:ro \
    -v $PWD/output:/output \
    rok4/pytools \
    tmsizer -i /input/logs.txt --tms PM -io levels=15,14 -io layers=LAYER.NAME1,LAYER.NAME2,LAYER.NAME3 -if GETTILE_PARAMS -of HEATMAP -oo area=FXX -oo level=15 -o /output/heatmap.tif
```

Documentation complète de l'outil [ici](https://rok4.github.io/pytools/latest/#tmsizer).
