# mon_service_redis Redis - Simple et Efficace

## 📁 Structure minimaliste

```
socle_rabbitmq/
├── Dockerfile
├── justfile
├── .env.example
├── .gitignore
└── README.md
```

# RabbitMQ Service

Template RabbitMQ 4.1 Management pour micro-services avec Podman.

## Installation

```bash
git clone https://github.com/thedasken/socle_rabbitmq.git mon_service_rabbitmq
cd mon_service_rabbitmq
rm -rf .git
```

---

## 🚀 Installation en 30 secondes

```bash
# 1. Créer .env
cp .env.example .env

# 2. GO!
just build
just create
```

---

## Utilisation

```bash
just build      # Construire l'image
just create     # Créer et démarrer
just start      # Démarrer
just stop       # Arrêter
just clean      # Supprimer le pod
just logs       # Voir les logs
just cli        # Se connecter à rabbitmq
```

## Configuration

Modifiez `.env` pour changer le password et les noms.

## Connexion (données d'exemple, à modifier en fonction de votre configuration)

- **Host:** `127.0.0.1` (le réseau `network_name` mappe les ports des pods sur la machine locale grâce au bridge)
- **Port:** `5672` et `15672`
- **Login:** (voir `.env`)
- **Password:** (voir `.env`)

## Test rapide

```bash
just build
just create
# Uniquement si besoin d'un utilisateur custom et pas de guest - guest
# just seed

# Ou si déjà construit
just start
# Uniquement si besoin d'un utilisateur custom et pas de guest - guest
# just seed
```