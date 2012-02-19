class ApplicationController < ActionController::Base
  protect_from_forgery
protected
  def current_user
    @current_user ||= User.find_or_create_by :uid => session[ :user_id ]
  end

  def set_current_user_auth_token!
    current_user.auth_token = session[ :auth_token ]
    current_user.save!
  end
end
