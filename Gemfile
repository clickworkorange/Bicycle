source "https://rubygems.org"

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

gem "thin", ">= 1.8.2"

# My gems
gem "activejob-status", "~> 1.0.1"
gem "acts_as_list", "~> 1.1.0"
gem "awesome_nested_set", "~> 3.6.0"
gem "carrierwave", git: "https://github.com/clickworkorange/carrierwave", branch: "master"
gem "dartsass-sprockets", "~> 3.1.0"
gem "devise", "~> 4.9.2"
gem "friendly_id", "~> 5.5.0"
gem "kramdown", "~> 2.4.0"
gem "rails-i18n", "~> 7.0.8"
gem "rouge", "~> 4.2.0"
gem "ruby-vips", "~> 2.2.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mswin mswin64 mingw x64_mingw]
  gem "i18n-debug", "~> 1.2.0"
  gem "rspec"
  gem "rubocop", "~> 1.60", require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end
