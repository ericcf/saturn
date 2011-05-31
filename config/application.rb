require File.expand_path('../boot', __FILE__)

require 'rails/all'
# rack middleware for custom error pages
require 'goalie/rails'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Saturn
  class Application < Rails::Application
    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec
    end

    config.active_record.observers = :assignment_request_observer,
      :section_membership_observer

    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
