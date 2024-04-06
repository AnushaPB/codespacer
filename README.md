# Setting up GitHub codespaces for R

This repository provides an example workflow of how to setup a GitHub codespace for R. First, a Docker image with all the necessary dependencies is built using a GitHub Action and pushed to the GitHub Container Registry. Then, the .devcontainer files are used to build the codespace from this image. Some additional setup is also done to make sure the RStudio session starts automatically and is in the correct project.

This repository can be forked and used as a template for setting up your own codespace for R. There are only two  changes required:
1. Change the docker-image.yml to push the image to your github account (i.e., change `ghcr.io/anushapb/codespacer:latest` to `ghcr.io/yourusername/yourimagename:latest`)

2. Change the devcontainer.json file to use your image (i.e., change `ghcr.io/anushapb/codespacer:latest` to `ghcr.io/yourusername/yourimagename:latest`)
You will likely also want to update the install.R file to include any additional R packages you want to install.

This repository uses code from the following repositories:
1. https://github.com/boettiger-lab/nasa-topst-env-justice
2. https://github.com/revodavid/devcontainers-rstudio/tree/main

## 1. Building a Docker image

To build a Docker image for the codespace, we use a [Dockerfile](Dockerfile) that sets up the image with the necessary dependencies for running R. 

### 1.1 The Dockerfile

First, we write a Dockerfile that will set-up a Docker image that contains the necessary dependencies for running R in a codespace. The [Dockerfile](Dockerfile) is as follows:

```Dockerfile
# Start with the tidyverse v 4.3.1 image from rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3
# You can use other rocker images:https://rocker-project.org/images/
# For example for working with geospatial packages:
#FROM ghcr.io/rocker-org/devcontainer/geospatial:4.3

# Relabel docker (otherwise it will have the rocker description)
LABEL org.opencontainers.image.description=""

# Install any additional desired packages (edit the install.R script to add packages)
COPY install.R install.R
RUN Rscript install.R && rm install.R
```

To add R dependencies to the image, edit the [install.R](install.R) file with any packages you want to install:

```r
#! /usr/local/bin/Rscript
# Install R dependencies

# Add lines here for installing packages:

# For example:
# install.packages("wingen")
# remotes::install_github('AnushaPB/wingen')

print("R package installs complete!")
```

### 1.2 Building the Docker image

We will build the Docker image using a GitHub Action, which will automatically build the image and push it to the GitHub container registry whenever changes are made to the specified files. The GitHub Action is setup using the [docker-image.yml](.github/workflows/docker-image.yml) file in the [.github/workflows](.github/workflows) folder:

***edit this file to use your image (i.e., change `ghcr.io/anushapb/codespacer:latest` to `ghcr.io/yourusername/yourimagename:latest`)**

```yaml
name: docker-build
on:
  push:
    # Optional: specify paths for files that should trigger the action if changed 
    # In this case, the action is triggered when the Dockerfile or install.R are changed
    paths:
      - Dockerfile
      - .github/workflows/docker-image.yml
      - install.R
    branches: [ "main" ]
    # Publish semver tags as releases.
    tags: [ 'v*.*.*' ]

jobs:
  build:
    runs-on: ubuntu-latest
    permissions: write-all
    steps:
      - uses: actions/checkout@v4
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{github.actor}}
          password: ${{secrets.GITHUB_TOKEN}}
      - name: Build the Docker image
        # CHANGE from ghcr.io/anushapb/codespacer:latest to `ghcr.io/yourusername/yourimagename:latest`
        run: docker build . --file Dockerfile --tag ghcr.io/anushapb/codespacer:latest
      - name: Publish
        # CHANGE from ghcr.io/anushapb/codespacer:latest to `ghcr.io/yourusername/yourimagename:latest`
        run: docker push ghcr.io/anushapb/codespacer:latest
```

Anytime you change the DOckerfile, docker-image.yml, or install.R files, the Docker image will be built and pushed to the GitHub container registry **automatically!**. 

You can see the image here: [ghcr.io/anushapb/codespacer](https://github.com/AnushaPB/codespacer/pkgs/container/codespacer)

## 2. Setting up a devcontainer

We can now use the Docker image we've built as the base our codespace. We use three files to setup the codespace, all located in the [.devcontainer](.devcontainer/) folder.  The main file is the [devcontainer.json](.devcontainer/devcontainer.json) file. The other two files ([setup.sh](.devcontainer/setup.sh) and [welcome.sh](.devcontainer/welcome.sh)) are used to configure the RStudio session in the codespace. Without these extra files the Rstudio session will not start automatically and the session will not start within the repositories .RProject, however all of these things can technically be done manually within the codespace, if you don't want to use these files.

File overview:

1. [devcontainer.json](.devcontainer/devcontainer.json) - a json file which specifies how to setup the container (i.e., the Docker image to use, the extensions to install, and the settings for the codespace). 
***edit this file to use your image (i.e., change `ghcr.io/anushapb/codespacer:latest` to `ghcr.io/yourusername/yourimagename:latest`)**

1. [setup.sh](.devcontainer/setup.sh) - a shell script that runs when the codespace is created to setup the Rstudio session.

2. [welcome.sh](.devcontainer/welcome.sh) - a shell script that runs when the codespace is attached to setup the R project and welcome the user with a link to open Rstudio.

## 3. Running the codespace

Start the codespace by clicking on the green "Code" button on the repository page and selecting create codespace. The codespace will then start. 

![start codespace](start_codespace.png)

To open the RStudio session in the codespace follow the link in the welcome message or go to "ports" and open the 8787 port.