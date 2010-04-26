ADMIN_EMAIL_ADDRESS = if Rails.env.production?
                        "jonathan@storycog.com"
                      else
                        "tom@tomlocke.com"
                      end

APP_DOMAIN        = "www.planet-scicast.org"

APP_REPLY_ADDRESS = "no-reply@#{APP_DOMAIN}"