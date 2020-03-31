Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true


  config.action_mailer.delivery_method     = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV['SMTP_ADDRESS'],
    port:                 ENV['SMTP_PORT'],
    user_name:            ENV['SMTP_USERNAME'],
    password:             ENV['SMTP_PASSWORD'],
    authentication:       ENV['SMTP_AUTHENTICATION_TYPE'],
    domain:               ENV['SMTP_DOMAIN'],
    ssl:                  ENV['SMTP_USE_SSL'],
    tls:                  ENV['SMTP_USE_TLS'],
    openssl_verify_mode:  ENV['SMTP_OPENSSL_VERIFY_MODE'],
    enable_starttls:      ENV['SMTP_ENABLE_STARTTLS'],
    enable_starttls_auto: ENV['SMTP_ENABLE_STARTTLS_AUTO'],
    open_timeout:         ENV['SMTP_OPEN_TIMEOUT'],
    read_timeout:         ENV['SMTP_READ_TIMEOUT']
  }.compact.tap do |options|

    # Typecast several options to integers.
    %i[ port open_timeout read_timeout ].each do |option|
      options[option] = options[option].to_i if options.key?(option)
    end

    # Typecast several options to booleans.
    %i[ ssl tls enable_starttls enable_starttls_auto ].each do |option|
      if options.key?(option)
        options[option] = options[option] == 'true' ? true : false
      end
    end

    # Enable mailer only if variables are defined in environment.
  end if ENV.key?('SMTP_ADDRESS') && ENV.key?('SMTP_PORT')
  config.action_mailer.default_url_options = {
    host: ENV['URL_HOST'],
    protocol: ENV['URL_SCHEME']
  }

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  config.active_record.default_timezone = :local

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { host: "#{ENV['URL_SCHEME']}://#{ENV['URL_HOST']}", port: 80}
end
