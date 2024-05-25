Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: "/usr/share/GeoIP/GeoLite2-City.mmdb"
  }
)