# 🌐 Configuration de Traefik avec Docker

Ce projet configure **Traefik**, un reverse proxy moderne et flexible, avec **Docker** et **Docker Compose**. Il prend en charge le routage dynamique, les certificats SSL via Let's Encrypt, et l'authentification HTTP de base.

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

- **Docker** et **Docker Compose** installés sur votre machine.
- Un fichier `.env` basé sur le modèle fourni (`.env.exemple`).

---

## 📂 Structure du Projet

Voici les principaux fichiers et leur rôle :

- **Dockerfile** : Définit l'image Docker pour Traefik.
- **compose.yml** : Configuration Docker Compose pour le déploiement.
- **.env.exemple** : Exemple de fichier d'environnement pour configurer les variables nécessaires.
- **.htpasswd** : Fichier pour l'authentification HTTP de base.
- **letsencrypt/** : Répertoire pour stocker les certificats SSL générés par Let's Encrypt.

---

## 🚀 Démarrage

### 1. Créer un fichier `.env`

Copiez le fichier `.env.exemple` et modifiez-le selon vos besoins :

```bash
cp .env.exemple .env
```

### 2. Construire et démarrer les services

Exécutez la commande suivante pour démarrer Traefik :

```bash
docker compose up -d
```

Traefik sera accessible à l'adresse configurée dans votre fichier `.env` (par exemple, [http://localhost](http://localhost)).

---

## 🔒 Authentification HTTP de Base

Le fichier `.htpasswd` contient les informations d'identification pour protéger l'accès au tableau de bord de Traefik. Vous pouvez générer un nouveau fichier `.htpasswd` avec la commande suivante :

```bash
htpasswd -nb <username> <password>
```

Exemple :

```bash
htpasswd -nb admin mypassword
```

Copiez la sortie dans le fichier `.htpasswd`.

---

## 🌍 Certificats SSL avec Let's Encrypt

Les certificats SSL sont automatiquement générés et stockés dans le répertoire `letsencrypt/`. Assurez-vous que ce répertoire est accessible en écriture par Traefik.

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
# Traefik settings
TRAEFIK_DOMAIN=example.com
TRAEFIK_EMAIL=admin@example.com

# HTTP Basic Auth
TRAEFIK_AUTH_USER=admin
TRAEFIK_AUTH_PASSWORD_HASH=$apr1$example$hashedpassword
```

---

## 📬 Support

Si vous avez des questions ou des problèmes, n'hésitez pas à ouvrir une issue ou à me contacter.