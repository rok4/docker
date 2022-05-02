# Outils de génération du projet ROK4 conteneurisés

Cette suite d'outil permet la manipulation des données images (reprojection, réechantillonnage, superposition...) ainsi que la mise au format final des données (écriture des dalles des pyramides ROK4).

La documentation complète est disponible [ici](https://github.com/rok4/generation), avec le code source.

Il existe également des exemples complets d'utilisation des images de prégénération et génération [ici](https://github.com/rok4/docker/tree/master/run/datasets).

## Outils

* CACHE2WORK : passage d'une dalle de pyramide raster au format de travail (détuilage et décompression)
* CHECKWORK : contrôle de la conformité d'une image de travail aux formats gérés par les outils
* COMPOSENTIFF : fusion d'images respectant une grille en une seule
* DECIMATENTIFF : assemblage d'images et décimation
* MANAGENODATA : identification du masque de donnée et modification des pixels de nodata
* MERGE4TIFF : fusion de 4 images en carré et sous échantillonnage
* MERGENTIFF : assemblage d'images, réechantillonnage et reprojection
* OVERLAYNTIFF : superposition d'images de même dimensions
* PBF2CACHE : conditionnement de fichiers PBF en une dalle de donnée vecteur
* WORK2CACHE : passage d'une image au format de travail à une dalle de pyramide raster (tuilage et compression)

## Exemple d'appel d'une commande

```bash
docker run --rm \
    --user $(id -u):$(id -g) \
    -v $PWD/inputs:/inputs:ro \
    -v $PWD/output:/output \
    rok4/generation:develop-debian11 \
    mergeNtiff -f /inputs/conf.txt -p /inputs/pente.json -c zip -i lanczos -n -99999
```

Avec les fichiers :

* de configuration `./inputs/conf.txt` :
```
IMG /output/image.tif       EPSG:3857       700000   5807000 715000  5792000 20      20
IMG /inputs/mnt.tif   IGNF:LAMB93     959997.500000000000     6565002.500000000000    964997.500000000000     6560002.500000000000    50.00000000000  50.00000000000
```
* de style `./inputs/pente.json`
* de données MNT `./inputs/mnt.tif`


## Exemple d'appel d'un script issu de la prégénération

```bash
docker run --rm \
    --user $(id -u):$(id -g) \
    -v $PWD/data:/data:ro \
    -v $PWD/pyramids:/pyramids \
    -v $PWD/scripts:/scripts \
    -v $PWD/common:/common \
    rok4/generation \
    bash /scripts/main.sh 10
```