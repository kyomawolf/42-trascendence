DOCKER_COMPOSE_FILE = ./docker-compose.yml

all: up

up:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down