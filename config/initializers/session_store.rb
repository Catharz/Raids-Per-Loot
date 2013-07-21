# Be sure to restart your server when you modify this file.

#RaidsPerLoot::Application.config.session_store :cookie_store, :key => '_rpl_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# RaidsPerLoot::Application.config.session_store :active_record_store

RaidsPerLoot::Application.config.session_store :cookie_store

RaidsPerLoot::Application.config.session = {
    :key => '_rpl_session',   # name of cookie that stores the data
    :domain => nil,           # you can share between subdomains here: '.communityguides.eu'
    :expire_after => 1.month, # expire cookie
    :secure => false,         # fore https if true
    :httponly => true,        # a measure against XSS attacks, prevent client side scripts from accessing the cookie

    :secret => 'cb8e1ac9dd5f4d08974f9f4d74abb45239a98b6cc3c59829ce6b61280160c421b4c18b0a721c26e0b4f43c1195875902...'
}