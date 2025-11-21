# 🌐 Déploiement d'une Application Django avec Docker

Ce projet contient une configuration complète pour déployer une application **Django** avec **Docker** et **Docker Compose**. Il inclut également des services complémentaires comme PostgreSQL, Redis, et Celery.

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

- **Docker** et **Docker Compose** installés sur votre machine.
- Un fichier `.env` basé sur le modèle fourni (`.env.exemple`).

---

## 📂 Structure du Projet

Voici les principaux fichiers et leur rôle :

- **Dockerfile** : Définit l'image Docker pour l'application Django.
- **compose.yml** : Configuration Docker Compose pour le développement.
- **compose.deploy.yml** : Configuration Docker Compose pour le déploiement.
- **entrypoint.deploy.sh** : Script d'entrée pour collecter les fichiers statiques et appliquer les migrations.
- **.env.exemple** : Exemple de fichier d'environnement pour configurer les variables nécessaires.

---

## 🚀 Démarrage en Développement

### 1. Créer un fichier `.env`

Copiez le fichier `.env.exemple` et modifiez-le selon vos besoins :

```bash
cp .env.exemple .env
```

### 2. Construire et démarrer les services

Exécutez la commande suivante pour démarrer les conteneurs en mode développement :

```bash
docker compose up --build
```

L'application sera accessible à l'adresse suivante : [http://localhost:8000](http://localhost:8000).

---

## 🌍 Déploiement

### 1. Construire et déployer les services

Pour déployer l'application, utilisez le fichier `compose.deploy.yml` :

```bash
docker compose -f compose.deploy.yml up -d
```

### 2. Accéder à l'application

L'application sera accessible via le domaine ou l'adresse IP configurée dans votre fichier `.env` (variable `WEB_APP_HOST`).

---

## 🛠️ Commandes Utiles

- **Arrêter les conteneurs** :
  ```bash
  docker compose down
  ```

- **Recréer les conteneurs** :
  ```bash
  docker compose up --build
  ```

- **Vérifier les logs** :
  ```bash
  docker compose logs -f
  ```

---

## 📄 Exemple de Configuration `.env`

Voici un exemple de fichier `.env` :

```env
# Django settings
DEBUG=True
SECRET_KEY=your_secret_key
ALLOWED_HOSTS=localhost,127.0.0.1,webapp.local

# Database settings
POSTGRES_DB=postgres_db
POSTGRES_USER=postgres_user
POSTGRES_PASSWORD=postgres_password
POSTGRES_HOST=webapp_db
POSTGRES_PORT=5432

# Redis settings
REDIS_HOST=redis
REDIS_PORT=6379
```

---

## 🧩 Services Inclus

- **Django** : Framework principal pour l'application.
- **PostgreSQL** : Base de données relationnelle.
- **Redis** : Cache pour Celery.
- **Celery** : Gestionnaire de tâches asynchrones.

---

## 📬 Support

Si vous avez des questions ou des problèmes, n'hésitez pas à ouvrir une issue ou à me contacter.
