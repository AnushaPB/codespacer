# Dockerfile modified from: http://haines-lab.com/post/2022-01-23-automating-computational-reproducibility-with-r-using-renv-docker-and-github-actions/
# Start with geospatial v 4.3.1
FROM ghcr.io/rocker-org/devcontainer/geospatial:4.3

# Relabel docker
LABEL org.opencontainers.image.description=""

# Use renv version 1.0.2
ENV RENV_VERSION 1.0.2

# Install renv
RUN Rscript -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# Create a directory named after our project directory
WORKDIR /codespacer

# Copy the lockfile over to the Docker image
# (there must be an renv.lock file at the same level of the Dockerfile, or provide a relative path)
COPY renv.lock renv.lock
# Install all R packages specified in renv.lock
RUN Rscript -e 'renv::restore()'

# Install any additional desired packages (edit the install.R script to add packages)
COPY install.R install.R
RUN Rscript install.R && rm install.R