source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'
gem 'uglifier'
gem 'mysql2'
gem 'haml'
gem 'sass-rails', '~> 3.1.0'
gem 'will_paginate', '~> 3.0'
gem 'formtastic', '~> 2.0.0.rc'
gem 'jquery-rails'
gem 'friendly_id'

# custom error pages
gem 'goalie'

gem 'rad_directory_client',
  :git => 'git://github.com/ericcf/rad_directory_client.git',
  :branch => "rails31"

# authentication/authorization
gem 'deadbolt', :git => 'git://github.com/ericcf/deadbolt.git'
gem 'devise'
gem 'cancan'

# Excel export
gem 'ekuseru'

# iCalendar import/export
gem 'vpim'
gem 'icalendar'

# Deployment
gem 'capistrano'
gem 'exception_notification', :git => 'git://github.com/rails/exception_notification', :require => 'exception_notifier'

group :development, :test do
  gem 'launchy'
  gem 'rspec-rails'
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'webrat', '~> 0.7.3'
  gem 'capybara-webkit', '~> 0.6.1' #, :git => 'git://github.com/thoughtbot/capybara-webkit.git'
  gem 'shoulda', '>= 3.0.0.beta'
  gem 'jasmine'
  gem 'rad_matchers'
  gem 'fakeweb'
  gem 'factory_girl_rails'
  gem 'chronic'
end
