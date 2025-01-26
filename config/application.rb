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

def load_site()
  # Check if there's a config for this site
  root = File.expand_path('../..', __FILE__)
  # Use Rails application parent directory name as site identifier 
  site_config = File.join(root, "sites", File.basename(root), "config/site.yml")
  if File.file?(site_config)
    YAML.load_file(site_config)
  else 
    # Load default config
    YAML.load_file("#{root}/config/site.yml")
  end
end

SITE = load_site()

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
      # TODO: move this and site_asset helpers out of the Rails::Application class (to a Site class?)
      # Rails.root / "sites" / SITE["root"] / path # this doesn't return a string
      "#{Rails.root}#{SITE["root"]}/#{path}"
    end

    def site_asset(asset)
      # Fall back to app/assets/[type]/[asset] unless site overrides the file. 
      # TODO: Use SassC::Rails::Importer from dartsass-rails to resolve stylesheets?
      # TODO: Incomplete filename support (e.g. "global" vs "_global.scss")
      # TODO: Extend to types other than stylesheets
      case File.extname(asset)
      when ".css", ".scss"
        type = "stylesheets"
      end
      site_asset = site_path(File.join("app", "assets", type, File.basename(asset)))
      File.file?(site_asset) ? site_asset : asset
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

    config.assets.configure do |assets|
      ["stylesheets", "javascript", "images", "fonts"].each do |type|
        assets.prepend_path(site_path("app/assets/#{type}"))
      end
    end
    config.assets.precompile += %w(site.js site.css bicycle.js bicycle.css *.jpg *.png *.svg)

    config.after_initialize do
      ActionController::Base.prepend_view_path(site_path("app/views"))
    end
  end
end