# ROK4 & Docker

## Compilation des images applicatives

Dans le dossier `build`

### Compilation depuis des sources locales

`bash build-from-local.sh --tag 0.0.1 --os debian11 --component server|generation|pregeneration|tools [--git-host https://github.com] [--proxy http://proxy.com:3128]`

### Compilation depuis des sources sur un dépôt GIT

`bash build-from-git.sh --tag 0.0.1 --os debian11 --component server|generation|pregeneration|tools --root /home/dlopper/rok4 [--proxy http://proxy.com:3128]`

## Exécution des images applicatives

* [Génération de pyramides](./run/datasets/README.md)
* [Exécution d'une stack avec le serveur](./run/server/README.md)