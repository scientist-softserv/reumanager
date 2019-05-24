require_relative 'boot'

require 'rails/all'
require 'apartment/elevators/subdomain'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Reuman
  class Application < Rails::Application
    Apartment::Elevators::Subdomain.excluded_subdomains = ['www', 'web', 'admin', '']
    config.middleware.use Apartment::Elevators::Subdomain

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true
    config.load_defaults 5.1
  end

  class Apartment < ::Apartment::Elevators::Subdomain
    def call(env)
      super
    rescue ::Apartment::TenantNotFound
      [302, { 'Location' => '/' }, []]
    end
  end
end
