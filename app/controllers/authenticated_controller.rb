class AuthenticatedController < ApplicationController
  before_filter :require_authentication_keys
private
  def require_authentication_keys
    active_keys = [ :auth_token , :user_id ]
    has_active_keys = active_keys.inject { | memo , key | memo && session.include?( key ) }
    redirect_to root_path unless has_active_keys
  end
end
