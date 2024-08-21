#!/bin/bash

# Path to the configuration file
PROJECT_DIR=$1 # corresponds to $ProjectFileDir$
CONFIG_FILE_DIR=".idea/runConfigurations/"
CONFIG_FILE_NAME="_template__of_JavaScriptTestRunnerJest.xml"

echo "dir: $1"
# Ensure the file exists
if [[ ! -f "$PROJECT_DIR/$CONFIG_FILE_DIR/$CONFIG_FILE_NAME" ]]; then
    echo "Configuration file not found! Creating a default one"
    mkdir -p $PROJECT_DIR/$CONFIG_FILE_DIR
    cat <<EOL > $PROJECT_DIR/$CONFIG_FILE_DIR/$CONFIG_FILE_NAME
    <component name="ProjectRunConfigurationManager">
      <configuration default="true" type="JavaScriptTestRunnerJest">
        <config-file value="\$PROJECT_DIR$/jest.unit.config.ts" />
        <node-interpreter value="project" />
        <node-options value="--experimental-vm-modules" />
        <jest-package value="\$PROJECT_DIR$/node_modules/jest" />
        <envs />
        <scope-kind value="ALL" />
        <method v="2" />
      </configuration>
    </component>
EOL
  echo "Default config file created."
else
# Toggle between the two config files using sed
sed -i '' -e 's|\$PROJECT_DIR\$/jest.unit.config.ts|TOGGLE_MARKER|' \
           -e 's|\$PROJECT_DIR\$/jest.integration.config.ts|\$PROJECT_DIR\$/jest.unit.config.ts|' \
           -e 's|TOGGLE_MARKER|\$PROJECT_DIR\$/jest.integration.config.ts|' \
           "$PROJECT_DIR/$CONFIG_FILE_DIR/$CONFIG_FILE_NAME"

# Output the result
echo "Toggled the config file between jest.unit.config.ts and jest.integration.config.ts"

fi


