class AuthController < ApplicationController
  def failure
    auth = request.env['omniauth.auth']
    raise auth.inspect
  end

  def callback
    auth = request.env['omniauth.auth']
    session[ :auth_token ] = auth[ "credentials" ][ "token" ]
    session[ :user_id ]    = auth[ "uid" ]
    set_current_user_auth_token!
    redirect_to repositories_path
  end
end
