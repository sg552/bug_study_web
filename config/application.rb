require File.expand_path('../boot', __FILE__)

require 'rails/all'
# add these line for log4r
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
include Log4r

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Peatio
  class Application < Rails::Application

    # Configure Sentry as early as possible.
    if ENV['SENTRY_DSN_BACKEND'].present? && ENV['SENTRY_ENV'].to_s.split(',').include?(Rails.env)
      require 'sentry-raven'
      Raven.configure { |config| config.dsn = ENV['SENTRY_DSN_BACKEND'] }
    end

    config.i18n.enforce_available_locales = false

    config.active_record.raise_in_transactional_callbacks = true

    config.assets.initialize_on_precompile = true

    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'

    config.paths.add 'lib', eager_load: false, autoload: true

    # assign log4r's logger as rails' logger.
    log4r_config= YAML.load_file(File.join(File.dirname(__FILE__),"log4r.yml"))
    YamlConfigurator.decode_yaml( log4r_config['log4r_config'] )
    config.logger = Log4r::Logger[Rails.env]
    config.log_level = :debug
  end
end

