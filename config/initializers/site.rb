
SITE = YAML.load_file("#{Rails.root}/sites/#{Pathname.getwd.basename}/config/site.yml")

# TODO: use try_files /SITE["root"]/public with fallback to Rails.root/public in nginx config

def site_path(file)
  "#{Rails.root}/sites/#{SITE["root"]}/#{file}"
end

Rails.application.config.credentials.content_path = site_path("config/credentials.yml.enc")
Rails.application.config.credentials.key_path = site_path("config/master.key")
Rails.application.config.i18n.load_path << site_path("config/locales/en.yml")
Rails.application.config.paths["config/database"] = site_path("config/database.yml")
Rails.application.config.assets.configure do |assets|
  # env.clear_paths
  ["fonts", "images", "javascript", "stylesheets", "config"].each do |type|
    assets.prepend_path(site_path("assets/#{type}"))
  end
end
Rails.application.config.paths["public"] = site_path("public")

ActionController::Base.prepend_view_path(site_path("views"))

CarrierWave.configure do |config|
  config.root = site_path("public")
end

