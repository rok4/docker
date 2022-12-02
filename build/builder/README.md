# Compilation des artefacts du projet ROK4 avec docker


## Compilation des images de compilation

```bash
docker build -t rok4/builder:alpine3 -f alpine3.Dockerfile .
docker build -t rok4/builder:debian11 -f debian11.Dockerfile .
docker build -t rok4/builder:debian12 -f debian12.Dockerfile .
```

## Génération des artefacts

Il y a la possibilité de compiler le code local à la machine, ou de récupérer la version taggée sur GitHub. Pour du code local, il suffit de monter le code source du composant voulu dans `/sources/<composant>`. Exemples :

```bash
# Depuis le code local
docker run --rm -v /home/ign/rok4/core-perl:/sources/core-perl -v /home/ign/rok4/:/artefacts rok4/builder:debian11 core-perl 1.0.0
# Depuis le code sur GitHub
docker run --rm -v /home/ign/rok4/:/artefacts rok4/builder:debian11 core-perl 1.0.0
```

Dans les commandes suivantes, on montrera l'exemple de compilation depuis GitHub

### Projet `server`

Commandes : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 server 4.0.0
docker run --rm -v $PWD:/artefacts rok4/builder:debian12 server 4.0.0
docker run --rm -v $PWD:/artefacts rok4/builder:alpine3 server 4.0.0
```

Artefacts :

* `rok4-server-4.0.0-alpine3-amd64.tar.gz`
* `rok4-server-4.0.0-debian11-amd64.deb`
* `rok4-server-4.0.0-debian11-amd64.tar.gz`
* `rok4-server-4.0.0-debian12-amd64.deb`
* `rok4-server-4.0.0-debian12-amd64.tar.gz`

### Projet `generation`

Commandes : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 generation 4.0.0
docker run --rm -v $PWD:/artefacts rok4/builder:debian12 generation 4.0.0
docker run --rm -v $PWD:/artefacts rok4/builder:alpine3 generation 4.0.0
```

Artefacts :

* `rok4-generation-4.0.0-alpine3-amd64.tar.gz`
* `rok4-generation-4.0.0-debian11-amd64.deb`
* `rok4-generation-4.0.0-debian11-amd64.tar.gz`
* `rok4-generation-4.0.0-debian12-amd64.deb`
* `rok4-generation-4.0.0-debian12-amd64.tar.gz`

### Projet `core-perl`

Commande : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 core-perl 1.0.0
```

Artefacts :

* `librok4-core-perl-1.0.0-linux-all.deb`
* `librok4-core-perl-1.0.0-linux-all.tar.gz`


### Projet `pregeneration`

Commande : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 pregeneration 4.0.0
```

Artefacts :

* `rok4-pregeneration-4.0.0-linux-all.deb`
* `rok4-pregeneration-4.0.0-linux-all.tar.gz`

### Projet `tools`

Commande : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 tools 4.0.0
```

Artefacts :

* `rok4-tools-4.0.0-linux-all.deb`
* `rok4-tools-4.0.0-linux-all.tar.gz`

### Projet `styles`

Commande : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 styles 4.0
```

Artefacts :

* `rok4-styles-4.0-linux-all.deb`
* `rok4-styles-4.0-linux-all.tar.gz`

### Projet `tilematrixsets`

Commande : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 tilematrixsets 4.0
```

Artefacts :

* `rok4-tilematrixsets-4.0-linux-all.deb`
* `rok4-tilematrixsets-4.0-linux-all.tar.gz`

### Projet `tippecanoe`

C'est un projet externe (https://github.com/mapbox/tippecanoe), dont les artefacts ne sont pas forcément disponibles au format requis. On va donc les compiler de la même manière que les composants ROK4. Seul l'exécutable `tippecanoe` est nécessaire

Commandes : 

```bash
docker run --rm -v $PWD:/artefacts rok4/builder:debian11 tippecanoe master
docker run --rm -v $PWD:/artefacts rok4/builder:debian12 tippecanoe master
docker run --rm -v $PWD:/artefacts rok4/builder:alpine3 tippecanoe master
```

Artefacts :

* `tippecanoe-master-alpine3`