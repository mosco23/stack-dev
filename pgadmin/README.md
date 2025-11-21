# 🐘 Déploiement de pgAdmin avec Docker

Ce projet configure **pgAdmin**, un outil web pour gérer vos bases de données PostgreSQL, à l'aide de **Docker** et **Docker Compose**.

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

- **Docker** et **Docker Compose** installés sur votre machine.
- Un fichier `.env` pour configurer les variables nécessaires.

---

## 📂 Structure du Projet

Voici les principaux fichiers et leur rôle :

- **compose.yml** : Configuration Docker Compose pour déployer pgAdmin.
- **.env** : Fichier d'environnement pour définir les variables nécessaires.
- **README.md** : Documentation pour utiliser ce projet.

---

## 🚀 Démarrage

### 1. Configurer les variables d'environnement

Assurez-vous que le fichier `.env` contient les informations nécessaires. Voici un exemple de configuration :

```env
# Configuration de pgAdmin
PGADMIN_DEFAULT_EMAIL=admin@example.com
PGADMIN_DEFAULT_PASSWORD=admin
PGADMIN_PORT=5050
```

### 2. Démarrer pgAdmin

Exécutez la commande suivante pour démarrer le conteneur :

```bash
docker compose up -d
```

pgAdmin sera accessible à l'adresse suivante : [http://localhost:5050](http://localhost:5050).

Utilisez les identifiants définis dans le fichier `.env` pour vous connecter.

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

## 📬 Support

Si vous avez des questions ou des problèmes, n'hésitez pas à ouvrir une issue ou à me contacter.