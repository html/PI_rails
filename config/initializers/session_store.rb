# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pi_session',
  :secret      => 'a9788c70fa661cae35641b8e24a27ced4be2ad4f21eb0d7c25928dc6312e622ada7122b1c21af9eea5c52efb6d826929d90af9d8cca3836b975a04c421af7f3c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
