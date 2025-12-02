# Charge automatiquement les variables de .env
set dotenv-load := true

# On veut un shell moderne
set shell := ["bash", "-c"]

# --- Tasks ---

build:
    echo "INFO - Construction de l'image..."
    podman build -t "${IMAGE_NAME}" .

create:
    # Vérifier .env
    if [[ ! -f .env ]]; then \
      echo "ERROR - Fichier .env manquant !"; \
      exit 1; \
    fi

    # Créer réseau et volume si nécessaire
    echo "INFO - Création du volume et du réseau nécessaires au pod..."
    podman network exists "${NETWORK_NAME}" || podman network create "${NETWORK_NAME}"

    # Créer le pod
    echo "INFO - Création du pod..."
    podman pod create \
        --name "${POD_NAME}" \
        -p "${PORT}:5672" \
        -p "${MANAGEMENT_PORT}:15672" \
        --net "${NETWORK_NAME}"

    # Démarrer le conteneur RabbitMQ
    echo "INFO - Démarrage du conteneur sur le port spécifié..."
    podman run -d --pod "${POD_NAME}" \
        --name "${CONTAINER_NAME}" \
        --env-file .env \
        -v "${VOLUME_NAME}:/var/lib/rabbitmq:Z" \
        "${IMAGE_NAME}"

seed user password:
    echo "INFO - Création de l'utilisateur RabbitMQ '{{user}}'..."

    podman exec ${CONTAINER_NAME} rabbitmqctl add_user "{{user}}" "{{password}}"

    podman exec ${CONTAINER_NAME} rabbitmqctl set_user_tags admin administrator

    podman exec ${CONTAINER_NAME} rabbitmqctl set_permissions -p / "{{user}}" ".*" ".*" ".*"

start:
    echo "INFO - Démarrage du conteneur sur le port spécifié..."
    podman pod start "${POD_NAME}"

stop:
    echo "INFO - Arrêt du conteneur..."
    podman pod stop "${POD_NAME}" 2>/dev/null || true

clean:
    echo "INFO - Demande de suppression du pod (en conservant les données des volumes)..."
    podman pod rm -f "${POD_NAME}" 2>/dev/null || true

clean-all:
    echo "INFO - Demande de suppression du pod (en supprimant les données des volumes y compris le backup)..."
    podman pod rm -f "${POD_NAME}" 2>/dev/null || true
    podman volume rm "${VOLUME_NAME}" 2>/dev/null || true

logs:
    podman logs -f "${CONTAINER_NAME}"

cli:
    echo "INFO - Demande d'éxécution du shell du pod..."
    podman exec -it "${CONTAINER_NAME}" /bin/bash
