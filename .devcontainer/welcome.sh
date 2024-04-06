# Modified from: https://github.com/boettiger-lab/nasa-topst-env-justice/blob/main/.devcontainer/setup.sh

# Automatically load the correct .Rproject in the Rstudio session -----------------------------------------

# Create a directory to store RStudio project settings
mkdir -p ~/.local/share/rstudio/projects_settings

# Find the .Rproj file in the current directory and assign it to the RPROJ variable
export RPROJ"=$(ls ${CODESPACE_VSCODE_FOLDER}/*.Rproj)"

# Write the path of the .Rproj file to the last-project-path file in the RStudio project settings directory
echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path

# Construct the welcome message ----------------------------------------------------------------------------

message="## [Open in RStudio](https://$CODESPACE_NAME-8787.app.github.dev)
"
# Echo the message to the terminal
echo "
👋 Welcome to Codespaces! You are on our custom image. 
   - It includes runtimes and tools for R using RStudio 

🌐 Open the RStudio editor here: https://$CODESPACE_NAME-8787.app.github.dev
   - (This may take a few seconds to load, retry if necessary)
"
