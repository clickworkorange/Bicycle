# Do not track admin users
Ahoy.exclude_method = lambda do |controller, request|
  # TODO: This is a bit messy
  if controller && request
    controller.current_user && controller.current_user&.admin
  else
    false
  end
end
# GDPR compliance
class Ahoy::Store < Ahoy::DatabaseStore
  def authenticate(data)
    # Disable automatic linking of visits and users
  end
end
# Anonymise IP addresses
Ahoy.mask_ips = true
# Do not use tracking cookies 
Ahoy.cookies = :none
# Do not track API requests
Ahoy.api = false
# Enable geocoding 
Ahoy.geocode = true
# TODO: Roll up time-series data after one year
# https://github.com/ankane/rollup