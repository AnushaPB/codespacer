#!/bin/bash
# Taken from: https://github.com/boettiger-lab/nasa-topst-env-justice/blob/main/.devcontainer/setup.sh

# Copies a configuration file to disable authentication on RStudio Server,
# making it accessible without needing to log in.
sudo cp /etc/rstudio/disable_auth_rserver.conf /etc/rstudio/rserver.conf

# Adds "USER=rstudio" to the end of the /etc/environment file,
# setting a system-wide environment variable to specify the default user for RStudio.
sudo sudo bash -c 'echo "USER=rstudio" >>/etc/environment'

# Start the RStudio Server in the background
sudo /init &> /dev/null &
