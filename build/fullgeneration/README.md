# Suite complète de génération du projet ROK4 conteneurisée

Cette image contient tous les outils de traitement et de gestion des pyramides de données, c'est à dire :

* les outil permettant d'écrire les scripts de génération ou de modification de pyramide ROK4 raster et vecteur. Ces outils font partie du projet, la documentation complète est disponible [ici](https://github.com/rok4/pregeneration), avec le code source.
* les outils permettant la manipulation des données images (reprojection, réechantillonnage, superposition...) ainsi que la mise au format final des données (écriture des dalles des pyramides ROK4). Ces outils font partie du projet, la documentation complète est disponible [ici](https://github.com/rok4/generation), avec le code source.
* les outils facilitant la gestion des pyramides (suppression, statistiques), la création de descripteur de couche par défaut, ainsi qu'un outil de conversion basé sur les TMS. Ces outils font partie du projet, la documentation complète est disponible [ici](https://github.com/rok4/tools), avec le code source.
* l'outil [tippecanoe](https://github.com/mapbox/tippecanoe), permettant le calcul des tuiles vectorielles
* la suite d'outil GDAL, permettant l'extraction des données vecteur

## Utilisation

Consulter les documentations sur les pages des images :

* [rok4/pregeneration](https://hub.docker.com/r/rok4/pregeneration)
* [rok4/generation](https://hub.docker.com/r/rok4/generation)
* [rok4/tools](https://hub.docker.com/r/rok4/tools)