# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_neweve_session',
  :secret      => '169a0d4a36ab571062ab72341ee8af547adff837b28b7c08b6f988e2bf9be68c2ad88a89a330321f6a19bf3e62a6c83ab537352491fc0bef21d368315bd1adb1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
