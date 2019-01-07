.PHONY: help clean
.DEFAULT_GOAL := help

COMMAND = docker-compose run --rm livro-aberto-djangoapp /bin/bash -c

all: update setup build install migrate run ## Setup and Install the Livro-Aberto APP using Docker.

setup: ## Setup the parameters and environment files.
	sh config/setup.sh

build: ## Build the Django APP Container from the Dockerfile
	docker-compose --project-name livro-aberto-djangoapp build

install: ## Install and Configure the Containers
	docker-compose up --no-start

run: ## Start the Containers generated in detached mode
	docker-compose up --detach

stop:  ## Stop the Containters generated
	docker-compose down

update: ## Update the submodule fetching from github
	git submodule update --init --remote --force
	
migrate: ## Run the database migration
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py migrate; pipenv run python manage.py loaddata data/181228_everything.json;'

clean: ## Clean all the images, networks and containers unused.
	docker system prune -a

help:
	@printf "\033[33m%s\033\n" "Projeto de Transparência Orçamentária da Secretaria Municipal da Educação de São Paulo"
	@printf "\033[32m%-30s\033[32m %s\033\n" "Commands" "Explanation"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'