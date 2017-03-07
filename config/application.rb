require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Traveltime
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    #Configure Cross-Origin Resource Sharing (CORS)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.active_record.time_zone_aware_types = [:datetime, :time]
    config.active_job.queue_name_prefix = Rails.env

    FIREBASE_KEY = "AAAAZ3gGsj4:APA91bEpMYJjti5khYaWrhzDmz5SHhu9u_JqZIK7Ua5zK7Z1O1cyVcp9ieYVlmH23vU32oVBr-xNF3eowkb-y-YHaPgnzAxMw0kahnhdAXqIqtDh1L6kla2aFQKE2gjkLKOTT2azeLyI"
    GCM = FCM.new(FIREBASE_KEY)
  end
end
