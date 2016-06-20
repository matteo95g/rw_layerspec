source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '>= 5.0.0.beta3', '< 5.1'

# change mongoid to stable version if stable version for rails 5 available
gem 'mongoid',      git: 'https://github.com/estolfo/mongoid.git', branch: 'MONGOID-4218-rails-5'
gem 'bson_ext'

gem 'oj'
gem 'oj_mimic_json'
gem 'active_model_serializers', '~> 0.10.0.rc5'
gem 'typhoeus', require: false

group :development, :test do
  gem 'rspec-rails', '3.5.0.beta2'
  gem 'byebug'
  gem 'faker'
  gem 'rubocop', require: false
  gem 'rspec-activejob'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-rails'
  gem 'mina'
  gem 'brakeman', require: false
  gem 'annotate'
end

group :test do
  gem 'timecop'
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
end

# Server
gem 'puma'
gem 'foreman'
gem 'dotenv-rails'
gem 'redis', '~> 3.2'
gem 'redis-namespace'
gem 'rack-cors'
gem 'rack-attack'
gem 'bcrypt'
gem 'sidekiq'
# gem 'newrelic_rpm'
