Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.consider_all_requests_local = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end



  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Temporarily storing images locally.
  config.active_storage.service = :local

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  Rails.application.routes.default_url_options = { host: 'lvh.me:3000' }


  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: 'lvh.me', port: 3000 }
  config.action_mailer.default_options = { from: 'no-reply@reumanager.com' }

  # mailtrap config
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: '133465770985d17a2',
    password: '3a16df65e72986',
    address: 'smtp.mailtrap.io',
    domain: 'smtp.mailtrap.io',
    port: '2525',
    authentication: :cram_md5
  }

  config.time_zone = 'Pacific Time (US & Canada)'

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  config.file_watcher = ActiveSupport::FileUpdateChecker

  config.web_console.whitelisted_ips = ['172.16.0.0/12', '192.168.0.0/16']
end
