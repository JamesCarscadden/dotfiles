#!/bin/bash -e

# Link Stuff

ln -si $PWD/vscode_settings ~/Library/Application\ Support/Code/User/settings.json

# Install Stuff
code --install-extension CraigMaslowski.erb
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension donjayamanne.createuniqueid
code --install-extension DotJoshJohnson.xml
code --install-extension groksrc.haml
code --install-extension groksrc.ruby
code --install-extension Kipters.codeshell
code --install-extension mohsen1.prettify-json
code --install-extension ms-vscode.PowerShell
code --install-extension ms-vscode.Theme-MarkdownKit
code --install-extension ms-vsts.team
code --install-extension msazurermtools.azurerm-vscode-tools
code --install-extension rebornix.Ruby
code --install-extension seanmcbreen.Spell
