source 'https://rubygems.org'
#for heroku deployment
ruby '1.9.3'
gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise'
gem 'haml'
gem "cancan"
gem 'nested_form'
group :production do
  gem 'pg'
end
group :development, :test do
  gem 'rspec-rails', '~> 2.0'             # for writing specs
  gem 'sqlite3'
  gem 'launchy'
end

group :development do
  gem 'spork-rails'
  gem 'guard'
  gem 'guard-rspec'
  # gem 'guard-spork'
end

gem 'copycopter_client', '~> 2.0.1'
gem "capybara", "~> 2.1.0"              # for integration testing

group :test do
  gem "factory_girl_rails", "~> 4.2.1"    # for creating test data
  gem 'simplecov'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
end

# gem 'guard-sass', :require => false
gem 'sass-rails',   '~> 3.2.3'
gem 'bootstrap-sass', '~> 2.3.2.0'
gem 'coffee-rails', '~> 3.2.1'
gem 'uglifier', '>= 1.0.3'

gem 'jquery-rails'