source 'http://rubygems.org'

gem 'rails'

gem 'mysql2'
gem 'haml'
gem 'jquery-rails'
gem 'mongrel', '= 1.2.0.pre2'
gem 'will_paginate', '~> 3.0.pre2'
gem 'formtastic'

gem 'rad_directory', :git => 'git://github.com/ericcf/rad_directory.git'
# required by Rad Directory
gem 'paperclip', :git => 'git://github.com/dwalters/paperclip.git', :branch => 'rails3'
# authentication/authorization
gem 'deadbolt', :git => 'git://github.com/ericcf/deadbolt.git'
gem 'devise'
gem 'cancan'

# Excel export
gem 'ekuseru'

# Excel import (roo and dependencies)
#gem 'roo'
#gem 'zip'
#gem 'google-spreadsheet-ruby'

# iCalendar import/export
gem 'vpim'
gem 'icalendar'

# Deployment
gem 'capistrano'

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'haml-rails'
  gem 'launchy'
  if RUBY_VERSION =~ /1.9/
    gem 'ruby-debug19', :require => 'ruby-debug'
  end
  gem 'rspec-rails'
  gem 'autotest-standalone'
  gem 'autotest-growl'
  gem 'database_cleaner'
  gem 'selenium-client'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'webrat'
  gem 'capybara'
  gem 'shoulda'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'jasmine'
  if RUBY_VERSION =~ /1.9/
    gem 'simplecov', '>= 0.3.5', :require => false
  end
end
