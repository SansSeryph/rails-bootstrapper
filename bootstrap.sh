#!/bin/bash

################################################################################
## Get the latest versions of everything
################################################################################

# ruby
asdf install ruby latest
asdf global ruby latest

# node
asdf install nodejs latest
asdf global nodejs latest

################################################################################
## Create project
################################################################################

cd ~/Workspace
rails new --main --css=sass podcast-site
cd podcast-site
git add .
git commit -m "Initialize new Rails project"

################################################################################
## Use HAML instead of ERB
################################################################################

bundle add haml-rails
rails generate haml:application_layout convert
rm app/views/layouts/applicaiton.html.erb
git add .
git commit -m "Install haml-rails gem"

################################################################################
## Install Devise
################################################################################

# TODO
