# Outils de prégénération du projet ROK4 conteneurisés

Cette suite d'outil permet d'écrire les scripts de génération ou de modification de pyramide ROK4 raster et vecteur.

La documentation complète est disponible [ici](https://github.com/rok4/pregeneration), avec le code source.

Il existe également des exemples complets d'utilisation des images de prégénération et génération [ici](https://github.com/rok4/docker/tree/master/run/datasets).

## Outils

* BE4 : génération d'une pyramide ROK4 raster à partir d'images géoréferencées ou par moissonnage d'un service WMS
* JOINCACHE : génération d'une pyramide ROK4 raster par assemblage de pyramides raster sources
* 4ALAMO : génération d'une pyramide ROK4 vecteur à partir de données sur PostgreSQL ou de fichiers GeoJSON
* 4HEAD : recalcul des niveaux du haut d'une pyramide raster à partir d'un niveau de référence
* PYR2PYR : recopie d'une pyramide d'un stockage à un autre

## Exemple d'appel d'une commande

```bash
docker run --rm \
    --user $(id -u):$(id -g) \
    -v $PWD/confs:/confs:ro \
    -v $PWD/data:/data:ro \
    -v $PWD/pyramids:/pyramids \
    -v $PWD/scripts:/scripts \
    -v $PWD/common:/common \
    rok4/pregeneration:${tag} \
    be4.pl --conf /confs/bdortho.json
```

Avec les fichiers :

* de configuration `./confs/bdortho.json` :
```json
{
    "datasources": [{
        "top": "0",
        "bottom": "15",
        "source": {
            "type": "IMAGES",
            "directory": "/data/",
            "srs": "IGNF:LAMB93"
        }
    }],
    "pyramid": {
        "type": "GENERATION",
        "name": "BDORTHO",
        "compression": "jpg",
        "tms": "PM.json",
        "storage": {
            "type": "FILE",
            "root": "/pyramids/BDORTHO"
        },
        "nodata": [255, 255, 255]
    },
    "process": {
        "directories": {
            "scripts": "/scripts",
            "local_tmp": "/tmp",
            "shared_tmp": "/common"
        },
        "parallelization": 2
    }
}
```
* de données : à décompresser dans `./data/` (1 Go en tout)
    * https://eu.ftp.opendatasoft.com/datacorsica/BDORTHO_2-0_RVB-5M00_JP2-E100_LAMB93_D02A_2016-01-01.7z
    * https://eu.ftp.opendatasoft.com/datacorsica/BDORTHO_2-0_RVB-5M00_JP2-E100_LAMB93_D02B_2016-01-01.7z