# Python Project Template
This template provides a basic structure for python projects.

It uses:
- [Poetry](https://python-poetry.org/docs/#installing-with-the-official-installer) as package manager
- [Pre-commit](https://pre-commit.com/) as CI pipeline for code formatting and linting
- [Docker](https://docs.docker.com/desktop/) for containerization

# How to install

## Dependencies 
- `make` (installable via `choco install make` on Windows)
- `Poetry` (PATH needs to be set)
- `Docker` (Installed and running)

## Installation

```bash
make init  # creates a .venv if not existing, installs modules and initializes pre-commit hooks
```

### Create new Readme
When set up, you should create a new Readme File that describes the project and its usage.

### Hide clutter (*PyCharm, optional*)
*Settings -> Editor -> File Types -> Ignore files and folders*
- poetry.lock
- .mypy_cache
- .pytest_cache
- .ruff_cache


# How to use
## Install packages
```bash
poetry add [package-name]
```

## Deploy to GCloud Run
- Set the `GCLOUD_PROJECT_ID`, `GCLOUD_ARTIFACT_REPO` and `GCLOUD_RUN_SERVICES` (space separated) variables in the `.env` file.
  - The services you define in `GCLOUD_RUN_SERVICES` each must correspond to one Dockerfile (e.g. having the service name as suffix after _Dockerfile-_) defined in `\.docker` 
    - for example, the default service name is *main*, corresponding to the `\.docker\Dockerfile-main`) 
  - These service names are used to build, push and deploy the services to GCloud Run.
- check you installed all dependencies using `poetry add` and not `pip install`
- First test the code locally, then locally as docker container, then deploy to GCloud Run.

```bash
# build, push and deploy all services
make full-deploy 
```

```bash
# build all services
make build
```

```bash
# push all services
make push
```
```bash
# deploy all services
make deploy
```

- A specific service can be chosen via: 
```bash
make [operation] SERVICES=[service] # (default: main)
```
