# 🚀 Déploiement Automatisé d’un Projet Django sur un VPS

Ce dépôt contient une configuration complète pour déployer automatiquement un projet **Django** sur un **VPS Linux** à l’aide de **Docker**, **Docker Compose**, et **GitHub Actions** (CI/CD).

---

## 🧰 Prérequis

- Un VPS fonctionnel (Ubuntu recommandé)
- Un compte GitHub avec accès au dépôt
- Docker et Docker Compose installés sur le VPS
- Un tag Git valide dans votre dépôt Git (ex: `v1.0.0`)

---

## 🔐 Clé SSH pour GitHub

### 1. Générer une nouvelle clé SSH

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_github
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_github 2>/dev/null
```

## 🔗 Configuration des Secrets GitHub

Dans votre dépôt GitHub, allez dans :
**Settings > Secrets and variables > Actions**, puis ajoutez les variables suivantes :

| Nom                   | Description                                                 |
| --------------------- | ----------------------------------------------------------- |
| `VPS_HOST`            | Adresse IP de votre VPS                                     |
| `VPS_PORT`            | Port SSH (par défaut : 22)                                  |
| `VPS_USERNAME`        | Utilisateur SSH (ex: `ubuntu`, `root`)                      |
| `VPS_SSH_PRIVATE_KEY` | Contenu de votre fichier `id_rsa_github`                    |
| `VPS_WORKDIR`         | Répertoire du projet sur le VPS                             |
| `ACCESS_TOKEN`        | Jeton GitHub (si vous utilisez GHCR pour les images Docker) |


## ⚙️ Installation sur le VPS
 
### Installer Docker
 
```bash

sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker $USER

```

**⚠️ Déconnectez-vous/reconnectez-vous pour que le groupe Docker soit pris en compte.**

### Installer Docker Compose

Méthode recommandée :

```bash

sudo apt install docker-compose-plugin

```
Ou version manuelle :

```bash

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.36.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version

```

## 📦 Fichiers essentiels

### Dockerfile

Définit l’environnement de l’application Django.

```dockerfile

FROM python:3.13-slim as builder

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt .
RUN apt-get update && \
    apt-get install -y python3-dev libpq-dev libglib2.0-0 libglib2.0-dev \
    libgirepository1.0-dev gir1.2-gtk-3.0 && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 80
CMD ["python3", "manage.py", "runserver", "0.0.0.0:80"]


```

### deploy-compose.yml

Orchestration Docker complète : Django, Postgres, Redis, PGAdmin.

```yml

services:
  suptrack:
    build:
      context: .
      dockerfile: Dockerfile
    entrypoint: [ "sh", "entrypoint.sh" ]
    container_name: suptrack-container
    restart: always
    volumes:
      - .:/app
    ports:
      - 8000:80
    networks:
      - custom_network
    depends_on:
      - redis
      - db

  db:
    image: postgres
    container_name: db-container
    restart: always
    environment:
      POSTGRES_DB: db
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: DEV12@
    expose:
      - 5432
    volumes:
      - ./database/data:/var/lib/postgresql/data
    user: "1000:1000"
    networks:
      - custom_network

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin-container
    restart: always
    ports:
      - 8800:80
    environment:
      PGADMIN_DEFAULT_EMAIL: dev@sukku.ovh
      PGADMIN_DEFAULT_PASSWORD: PostXR12@
    depends_on:
      - db
    networks:
      - custom_network

  redis:
    image: redis:alpine
    container_name: redis-container
    restart: always
    expose:
      - 6379
    networks:
      - custom_network

networks:
  custom_network:
    name: custom_network

```

## 🚀 Déploiement Automatisé avec GitHub Actions

Ce projet utilise GitHub Actions pour automatiser le déploiement sur ton VPS à chaque push ou création de tag sur la branche `main`.

## 📁 Fichier : .github/workflows/ci-cd.yml

Voici le contenu complet du fichier de pipeline CI/CD :

```yaml
name: Django CI Pipeline

on:
    push:
        branches:
            - main
    pull_request: 
        branches: 
            - main
jobs:
    deploy:
        runs-on: ubuntu-latest
        steps:
            - name: Checkout code
                uses: actions/checkout@v4
                with:
                    fetch-depth: 0

            - name: Get the latest git tag
                id: get_tag
                run: |
                    git fetch --tags

                    CURRENT_TAG=$(git describe --tags --abbrev=0)
                    PREVIOUS_TAG=$(git tag --sort=-creatordate | grep -v "$CURRENT_TAG" | head -n 1)

                    SAFE_CURRENT_TAG=$(echo "$CURRENT_TAG" | tr '.' '_' | tr '[:upper:]' '[:lower:]')
                    SAFE_PREVIOUS_TAG=$(echo "$PREVIOUS_TAG" | tr '.' '_' | tr '[:upper:]' '[:lower:]')

                    echo "CURRENT_TAG=$CURRENT_TAG" >> $GITHUB_ENV
                    echo "PREVIOUS_TAG=$PREVIOUS_TAG" >> $GITHUB_ENV
                    echo "SAFE_CURRENT_TAG=$SAFE_CURRENT_TAG" >> $GITHUB_ENV
                    echo "SAFE_PREVIOUS_TAG=$SAFE_PREVIOUS_TAG" >> $GITHUB_ENV

            - name: Log in to GitHub Container Registry
                uses: docker/login-action@v2
                with:
                    registry: ghcr.io
                    username: ${{ github.actor }}
                    password: ${{ secrets.ACCESS_TOKEN }}
            - name: SSH to VPS and deploy with Portainer
                uses: appleboy/ssh-action@v1.2.1
                with:
                    host: ${{ secrets.VPS_HOST }}
                    port: ${{ secrets.VPS_PORT }}
                    username: ${{ secrets.VPS_USERNAME }}
                    key: ${{ secrets.VPS_SSH_PRIVATE_KEY }}
                    script: |
                        echo "🔐 Activation de l'agent SSH"
                        eval "$(ssh-agent -s)"
                        ssh-add ~/.ssh/id_rsa_github 2>/dev/null

                        echo "📁 Déplacement dans le répertoire du projet"
                        cd ${{VPS_WORKDIR}}

                        echo "📥 Mise à jour du projet depuis Git"
                        git pull -f

                        echo "🔁 TAG actuel : ${{ env.CURRENT_TAG }}"
                        echo "🕓 TAG précédent : ${{ env.PREVIOUS_TAG }}"

                        if [ -n "${{ env.PREVIOUS_TAG }}" ]; then
                            echo "🛑 Arrêt de la stack Docker précédente (${{ env.SAFE_PREVIOUS_TAG }})"
                            docker compose -f deploy-compose.yml --project-name "${{ env.SAFE_PREVIOUS_TAG }}" down
                        else
                            echo "⚠️ Aucun tag précédent trouvé. Rien à arrêter."
                        fi


                        echo "🚀 Déploiement de la nouvelle stack (${{ env.SAFE_CURRENT_TAG }})"
                        docker compose -f deploy-compose.yml --project-name "${{ env.SAFE_CURRENT_TAG }}" up -d --build

                        echo "🧹 Nettoyage des ressources Docker inutilisées"
                        docker system prune -af

                        echo "📦 Conteneurs en cours d'exécution"
                        docker ps
```



## ✅ Utilisation

**Démarrer un déploiement :**

### 1. Pousser le code sur main
### 2. Créer un tag :

```bash

git tag v1.0.0
git push origin v1.0.0

```

Cela déclenchera automatiquement le pipeline CI/CD.


## 📂 Arborescence conseillée

```
.
├── Dockerfile
├── deploy-compose.yml
├── requirements.txt
├── entrypoint.sh
├── manage.py
├── myproject/
│   ├── settings.py
│   └── ...
└── .github/
    └── workflows/
        └── ci-cd.yml
```
