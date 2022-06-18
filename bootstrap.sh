#!/bin/bash

################################################################################
## Get the latest versions of everything
################################################################################

# ruby
asdf install ruby latest
asdf global ruby latest
asdf reshim ruby

# node
asdf install nodejs latest
asdf global nodejs latest
asdf reshim nodejs

################################################################################
## Create project
################################################################################

cd ~/Workspace
rails new --css=sass podcast-site
cd podcast-site
git add .
git commit -m "Initialize new Rails project"

################################################################################
## Rubocop
################################################################################

bundle add --group=development --require=false rubocop rubocop-rails \
  rubocop-performance rubocop-rspec rubocop-rake rubocop-faker
ln ~/Workspace/rails-bootstrapper/rubocop.yml ~/Workspace/podcast-site/.rubocop.yml
bundle exec rubocop --autocorrect
bundle exec rubocop --auto-gen-config
mv .rubocop_todo.yml .rails_rubocop_ignores.yml
git add .
git commit -m "Add and configure Rubocop"

################################################################################
## Test Suite
################################################################################

# RSpec
bundle add --group=development,test rspec-rails rubocop-rspec
# TODO Move installed gems to right spot
bundle exec rails generate rspec:install
# TODO: make updates around rubocop.yml
#       - move rspec rules to separate file (including require line)
#       - hard link rspec rules file
#       - cli command to add an includes statement in .rubocop.yml
bundle exec rubocop --autocorrect
git add .
git commmit -m "Add and configure RSpec"

# Factory Bot
bundle add --group=development,test factory_bot_rails
# TODO: move gem line to the right spot
mkdir -p spec/support/
ln ~/Workspace/rails-bootstrapper/factory_bot_rails.rb spec/support/
# TODO: cli command to include the factory bot file in `spec/rails_helper.rb`
bundle exec rubocop --autocorrect
git add .
git commmit -m "Add and configure Factory Bot"

################################################################################
## Use HAML instead of ERB
################################################################################

bundle add haml-rails
env HAML_RAILS_DELETE_ERB=true bundle exec rails haml:erb2haml
git add .
git commit -m "Add and configure HAML"

################################################################################
## Install Devise
################################################################################

# TODO
