# Dockerfile modified from: http://haines-lab.com/post/2022-01-23-automating-computational-reproducibility-with-r-using-renv-docker-and-github-actions/
# Start with geospatial v 4.3.1
FROM ghcr.io/rocker-org/devcontainer/geospatial:4.3

# Relabel docker (otherwise it will have the geospatial description)
LABEL org.opencontainers.image.description=""

# Install any additional desired packages (edit the install.R script to add packages)
COPY install.R install.R
RUN Rscript install.R && rm install.R
