if CONFIG.use_basic_auth == "true"
  Rails.application.config.middleware.use Rack::Auth::Basic , "Antiqua v0.1" do | username , password |
    valid_username = username == CONFIG.basic_auth_username
    valid_password = password == CONFIG.basic_auth_password
    valid_username && valid_password
  end
end
