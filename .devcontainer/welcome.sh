# Modified from: https://github.com/boettiger-lab/nasa-topst-env-justice/blob/main/.devcontainer/setup.sh

# Automatically load the correct .Rproject in the Rstudio session -----------------------------------------

# Create a directory to store RStudio project settings
mkdir -p ~/.local/share/rstudio/projects_settings

# Find the .Rproj file in the current directory and assign it to the RPROJ variable
export RPROJ"=$(ls ${CODESPACE_VSCODE_FOLDER}/*.Rproj)"

# Write the path of the .Rproj file to the last-project-path file in the RStudio project settings directory
echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path
