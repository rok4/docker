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

## Détails sur les jeux de données pré conteneurisé

### rok4/dataset:minio

Cette image, ayant pour base `minio/minio`, est un stockage S3 contenant les styles, les tile matrix sets, les pyramides et les descripteurs de couche. Ce stockage centralisé permet d'exploiter le fonctionnement du serveur ROK4 5.0.0.

Ce stockage se lance via la commande `docker run -p 9000:9000 -p 9001:9001 rok4/dataset:minio` et une interface graphique de gestion est disponible à l'URL `http://localhost:9001/buckets` (accès : rok4 / rok4S3storage)

Ce stockage contient les buckets suivants :

* `styles` : tous les styles du projet ROK4
* `tilematrixsets` : tous les tile matrix sets du projet ROK4
* `pyramids` : les pyramides BDORTHO, BDPACELLAIRE, ALTI, PENTE et LIMADM
* `layers` : l'objet liste `list.txt` et les descripteurs de couche BDORTHO, BDPACELLAIRE, ALTI, PENTE et LIMADM