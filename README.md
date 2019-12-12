# Docker Self-Install SME-Livro-Aberto
Created by: Raphael Sathler - DAPP FGV - 2019
Projeto de Transparência Orçamentária da Secretaria Municipal da Educação de São Paulo

# Why a self-install
We want to keep it simple, so, we have created a script to let it do the job for you and avoid problems as configuration and etc.

# Dependencies
You must have [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

# What it does?
This will create 3 containers, configure their network and let them run:

- Postgres, our database
- Nginx, our reverse proxy to get data
- APP, served by a http server known as [gunicorn](https://gunicorn.org/)

# How to clone?
As this has a submodule, you must clone using the recursive flag:
```
$ git clone --recurse-submodules git@github.com:prefeiturasp/SME-Livro-Aberto-Docker.git

```

# How to install?
TL;DR: 
```
$ make all
```

It will ask you all the necessary configuration parameters and then, install. 

> Remember: For any questions about how to run, you can always use:

```
$ make help
```

## Setting up
All you need to do is to execute these steps in order to install, dump up pre-loaded data, download APIs data from EOL and SOF, generate files to download and create data views on database.

## Step 1 - Database setup and Docker setup
This first step is responsible for the creations of the infrastructure needed. You will be prompted for any configuration of each component.
```
$ make stepe1
```

## Step 2 - Dump up pre-loaded data to the tools
The **Mosaico** and **Geologia** tools need a first load of raw data in order to gain some time on the first run. 
```
$ make step2
```

## Step 3 - Create Django`s admin user, setup and load
You will be prompted to set user and password to manage access on the Django Administrator Panel. After that, it will load pre-set data from contratos and generate the processed data to Contrato Social`s tool.
```
$ make step3
```

## Step 4 - Contrato Social's setup and load
This step is specific to the Contrato Social's tool, whicth is more slow, doe to the API SOF dependency.
```
$ make step4
```

## Step 5 - Regionalização's setup and load
This step load the schools from API EOL and apply the data associations between tables using spredsheets imported by admin.
```
$ make step5
```
