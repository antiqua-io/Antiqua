class AuthController < ApplicationController
  def failure
    auth = request.env['omniauth.auth']
    raise auth.inspect
  end

  def callback
    auth = request.env['omniauth.auth']
    initialize_session!      auth
    initialize_current_user! auth
    redirect_to repositories_path
  end

private

  def initialize_current_user!( auth_data )
    current_user.auth_token = auth_data[ "credentials" ][ "token" ]
    current_user.image_url  = auth_data[ "extra" ][ "raw_info" ][ "avatar_url" ]
    current_user.user_name  = auth_data[ "info" ][ "nickname" ]
    current_user.save!
  end

  def initialize_session!( auth_data )
    session[ :auth_token ] = auth_data[ "credentials" ][ "token" ]
    session[ :user_id ]    = auth_data[ "uid" ]
  end
end
