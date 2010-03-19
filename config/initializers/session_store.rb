# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_scicast_session',
  :secret      => '2e7d205ecb95cd8917a330ce2d803975491bf0e10b89f160886ec91028bc6266268d663c00582540c6bc07d28eef82e78e5a8d70dfa4006cd616d0a06db33672'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
