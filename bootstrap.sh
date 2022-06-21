#!/bin/bash

echo "Starting!"

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

bundle add --group=development --require=false rubocop-rails \
  rubocop-performance rubocop-rake
ln ~/Workspace/rails-bootstrapper/rubocop.yml \
  ~/Workspace/podcast-site/.rubocop.yml
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
HAML_RAILS_DELETE_ERB=true bundle exec rails haml:erb2haml
git add .
git commit -m "Add HAML gem and convert ERB files to HAML"

################################################################################
## Devise
################################################################################

# TODO: add route/controller/view for home? so that the root route below works

bundle add devise
bundle exec rails generate devise:install
# TODO: add the following line to `config/environments/development.rb`:
# `config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }`
# TODO: add the following as a comment to `config/environments/production.rb`:
# `config.action_mailer.default_url_options = { host: <host>, port: <port> }`
# TODO: add a root route to `config/routes.rb`: `root to: 'home#index'`
# TODO: in `app/views/layouts/application.html.haml`, add the following lines:
#       - .notice= notice
#       - .alert= alert
bundle exec rails generate devise:views
HAML_RAILS_DELETE_ERB=true bundle exec rails haml:erb2haml
bundle exec rails generate devise user
# TODO: config devise:
#       - pick modules in `app/models/user.rb`
#       - go through `config/initializers/devise.rb`
rm spec/models/user_spec.rb
bundle exec rubocop --autocorrect
git add .
git commit -m "Add and configure Devise"

################################################################################
## Yard
################################################################################

bundle add yard
git add .
git commit -m "Add Yard Gem"

################################################################################
## Post-Install Message
################################################################################

echo "Project Setup Complete!"
echo "You may want to do a few things manually:"
echo "- Clean up Gemfile"
echo "- Configure Devise"
