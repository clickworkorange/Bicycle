

Rails.application.config.session_store :cookie_store, key: "_bicycle_session", httponly: true, secure: Rails.env.production?, same_site: :strict, expire_after: 1.month
