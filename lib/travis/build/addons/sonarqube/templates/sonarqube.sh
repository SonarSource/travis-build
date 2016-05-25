#!/bin/bash

# home: path where scanner cli will be installed. Example: ${HOME}/.sonar
# version: version of scanner cli. Example: 2.5
install_sonar_scanner() {
  rm -rf <%= home %>
  mkdir -p <%= home %>
  curl -sSLo <%= home %>/sonar-scanner.zip http://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/<%= version %>/sonar-scanner-cli-<%= version %>.zip
  unzip <%= home %>/sonar-scanner.zip -d <%= home %>
}
