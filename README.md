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
$ git clone --recurse-submodules ssh://git@git.dapp.cloud.fgv.br:777/source/ot-dockerfile-sme-livro-aberto.git

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
Before everything, you must set up which versions you'll be using and configuring the database. To do so, use:
```
$ make setup
```

## Building up the APP
As the APP uses [Django](https://www.djangoproject.com/), we need to build it from the `Dockerfile`:
```
$ make build
```

## Installing
Once you've build the APP, now we can proceed to create the other containers from the [docker hub](https://hub.docker.com/) images:
```
$ make install
```

## Migrating
Now, we need to fill our database using:
```
$ make migrate
```

## Let it run
Finally, we can start our containers:
```
$ make run
```