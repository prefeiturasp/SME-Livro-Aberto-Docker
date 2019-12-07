.PHONY: help clean
.DEFAULT_GOAL := help

COMMAND = docker-compose run --rm livro-aberto-djangoapp /bin/bash -c
COMMAND_ON_RUNNING_CONTAINER = docker exec -i -t sme-livro-aberto-docker_livro-aberto-djangoapp_1 /bin/bash -c


all: update-submodule setup build install first-migration generate-executions create-super-user run ## Setup and Install the Livro-Aberto APP using Docker.

step1: update-submodule setup build install first-migration

step2: populate_row_load_with_dump

step3: create-super-user load-data generate-executions run

step4: get-data-contracts generate-executions-contratos

setup: ## Setup the parameters and environment files.
	/bin/bash config/setup.sh

build: ## Build the Django APP Container from the Dockerfile
	docker-compose --project-name livro-aberto-djangoapp build --force-rm --no-cache

install: ## Install and Configure the Containers
	docker-compose up --no-start

run: ## Start the Containers generated in detached mode
	docker-compose up --detach

stop:  ## Stop the Containers generated
	docker-compose stop

down: ## Remove the Containers generated and the networks
	docker-compose down --rmi 'all' --remove-orphans

remove: ## Remove the Containers generated and the volumes - WARNING: THIS OPTION WILL REMOVE THE DATABASE
	docker-compose down -v --rmi 'all' --remove-orphans

update-submodule: ## Update the submodule fetching from github
	git submodule update --init --remote --force

update: ## Update the submodule and send it to container
	git submodule update --init --remote --force
	make down build install migrate run
	
migrate: ## Run the database migration
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py migrate;'

create-super-user: ## Create the super user to access django-admin
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py createsuperuser;'

first-migration: ## Run the database migration - WARNING: THIS SHOULD BE USED ONLY ON THE FIRST TIME YOU'RE CREATING THE DATABASE
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py migrate;'

load-data: ## Load the data necessary for tests
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py runscript load_2003_2017_execucoes_and_generate_new_ones;'

generate-executions: ## Import data from tables orcamento e empenho and apply the fromto script.
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py runscript generate_execucoes;'

get-data-contracts: ## Get the contract data from API SOF based on contrato_raw_load table
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py runscript get_empenhos_for_contratos_from_sof_api;'

generate-executions-contratos: ## Cruza os dados das duas tabelas e aplica o de-para conforme script generate_execucoes_contratos
	$(COMMAND_ON_RUNNING_CONTAINER) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py runscript generate_execucoes_contratos;'

populate_row_load_with_dump: ## Load raw data with dump pre loaded on the main repository
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py runscript populate_orcamento_empenhos_raw_load_with_dump;'

update_regionalizacao_data: ## Baixa dados das escolas na API EOL, aplica de-paras e gera as execuções
	$(COMMAND) 'sleep 15; cd /opt/services/livro-aberto/src; pipenv run python manage.py runscript update_regionalizacao_data;'

clean: ## Clean all the images, networks and containers unused - WARNING: THIS OPTION WILL REMOVE ALL UNUSED IMAGES, NETWORKS AND CONTAINERS.
	docker system prune -a

help:
	@printf "\033[33m%s\033\n" "Projeto de Transparência Orçamentária da Secretaria Municipal da Educação de São Paulo"
	@printf "\033[32m%-30s\033[32m %s\033\n" "Commands" "Explanation"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'