# source 'http://gems.github.com'
source 'https://rubygems.org'

gem 'rails', '5.1.3'

gem 'activemodel-serializers-xml'

gem 'stripe'

gem 'addressable'
gem 'carmen-rails', git: 'https://github.com/notch8/carmen-rails.git', :branch => 'master'
# gem 'client_side_validations', github: "notch8/client_side_validations", :branch => "removed_repo"
gem 'client_side_validations', '~> 9.3', '>= 9.3.4'
gem 'cocaine', :git => 'git://github.com/thoughtbot/cocaine.git'
gem 'capistrano'
gem 'devise'
gem 'dotenv-rails'
gem 'factory_girl_rails'
gem 'faker'
gem 'haml'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'modernizr-rails'
gem 'pg'
gem 'paperclip', '~> 5.1'
gem 'paper_trail'
gem 'rails_admin', :git => "https://github.com/sferik/rails_admin.git"
gem 'rails-deprecated_sanitizer'
gem 'redcarpet'
gem 'responders', '~> 2.0'
# gem 'rich', :git => "https://github.com/joeswann/rich.git"
gem 'rich', :git => "https://github.com/notch8/rich.git"
gem 'mimemagic', '~> 0.3.2'
# gem 'rich'
gem 'rvm-capistrano', :require => false

group :development, :test do
  gem 'sqlite3'
end
# gem 'state_machine'
# gem 'state-machine', :git => "https://github.com/seuros/state_machine.git"
# gem 'state_machine', '~> 1.2'
gem 'state_machines-activerecord'
gem 'whenever', :require => false
gem 'validates_email_format_of'
gem 'apartment'

# Old assets group
gem 'bootstrap-sass', '~> 2.1'
gem 'bootstrap-datepicker-rails', :require => 'bootstrap-datepicker-rails', :git => 'https://github.com/Nerian/bootstrap-datepicker-rails.git'

gem 'coffee-rails'
# gem 'libv8'
gem 'modernizr-rails'
# gem 'therubyracer'
gem 'sass-rails', '~> 5.0'
gem 'uglifier'

# Gems for smooth transition to Rails 4
gem 'protected_attributes_continued'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'activerecord-deprecated_finders'

# Refinery
gem 'refinerycms', :git => "https://github.com/refinery/refinerycms.git", :branch => 'release/4.0.0'
gem 'refinerycms-authentication-devise', '~> 2.0.0'
# Add support for searching inside Refinery's admin interface.
gem 'refinerycms-acts-as-indexed'
# Add support for Refinery's custom fork of the visual editor WYMeditor.
gem 'refinerycms-wymeditor'

group :development do
  gem 'web-console', '~> 3.5'
  gem 'awesome_print'
  gem "better_errors"
  gem 'binding_of_caller'
  gem 'bond'
  gem 'crack'
#  gem 'quiet_assets'
  gem 'hirb-unicode'
  gem 'meta_request'
  gem 'rb-fchange', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
  gem 'ruby_gntp'
  gem 'simplecov'
  gem 'what_methods'
	gem 'wirble'
end

group :test, :development do
  gem 'capybara'
  # gem "capybara-webkit"
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'pry'
  gem 'rspec-rails', '~> 3.6', '>= 3.6.1'
end

group :test do
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'mocha', :require => "mocha/api"
  gem 'shoulda'
end
