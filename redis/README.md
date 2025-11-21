# 🚀 Déploiement de Redis avec Docker

Ce projet configure **Redis**, une base de données en mémoire rapide et flexible, à l'aide de **Docker** et **Docker Compose**.

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

- **Docker** et **Docker Compose** installés sur votre machine.

---

## 📂 Structure du Projet

Voici les principaux fichiers et leur rôle :

- **compose.yml** : Configuration Docker Compose pour déployer Redis.
- **data/** : Répertoire pour stocker les données persistantes de Redis.
- **README.md** : Documentation pour utiliser ce projet.

---

## 🚀 Démarrage

### 1. Démarrer Redis

Exécutez la commande suivante pour démarrer le conteneur Redis :

```bash
docker compose up -d
```

Redis sera accessible sur le port par défaut `6379`.

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

## 📂 Persistance des Données

Les données de Redis sont stockées dans le répertoire `data/`. Ce répertoire est monté dans le conteneur pour garantir la persistance des données même après l'arrêt du conteneur.

---

## 📬 Support

Si vous avez des questions ou des problèmes, n'hésitez pas à ouvrir une issue ou à me contacter.