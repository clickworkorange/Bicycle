require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"
# TODO: is this actually needed?
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Rails.root is not yet defined, so we set our own constant
ROOT = File.expand_path('../..', __FILE__)
# Use Rails application parent directory name as site identifier 
SITE = YAML.load_file(File.join(ROOT, "sites", File.basename(ROOT), "config/site.yml"))

module Clickworkorange
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    def site_path(path)
      # Rails.root / "sites" / SITE["root"] / path # this doesn't return a string
      "#{Rails.root}/sites/#{SITE["root"]}/#{path}"
    end

    config.credentials.content_path = site_path("config/credentials.yml.enc")
    config.credentials.key_path = site_path("config/master.key")

    config.i18n.load_path << site_path("config/locales/en.yml")
    config.paths["config/database"] = site_path("config/database.yml")
    config.paths["public"] = site_path("public")
    config.paths["public/javascripts"] = site_path("public/javascripts")
    config.paths["public/stylesheets"] = site_path("public/stylesheets")

    CarrierWave.configure do |carrierwave|
      carrierwave.root = site_path("public")
    end

    config.assets.configure do |env|
      ["stylesheets", "javascript", "images", "fonts"].each do |type|
        env.prepend_path(site_path("assets/#{type}"))
      end
    end
    config.assets.precompile += %w(site.js site.css bicycle.js bicycle.css icons/*.svg)

    config.after_initialize do
      ActionController::Base.prepend_view_path(site_path("views"))
    end
  end
end