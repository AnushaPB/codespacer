# Start with tidyverse v 4.3.1 from rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3
# You can use other rocker images:https://rocker-project.org/images/
# For example for working with geospatial packages:
#FROM ghcr.io/rocker-org/devcontainer/geospatial:4.3

# Relabel docker (otherwise it will have the rocker description)
LABEL org.opencontainers.image.description=""

# Install any additional desired packages (edit the install.R script to add packages)
COPY install.R install.R
RUN Rscript install.R && rm install.R
