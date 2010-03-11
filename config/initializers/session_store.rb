# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_schema4less_session',
  :secret => '2ec5919579fa2ee2c468fb5f19426bf8429c890e269bad7071336345e775fdbc5b45884098b54fb1b6f613832544e81c6f4b484c3d89e503c9428372a10e9450'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
